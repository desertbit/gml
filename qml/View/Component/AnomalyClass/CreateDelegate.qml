import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action.AnomalyClass as AAnomalyClass

import Lib as L
import Store
import Theme

import View.Component.Button as VCB
import View.Component.Form as VCF
import View.Component.Handler as VCH
import View.Component.Icon as VCI
import View.Component.List as VCL

Rectangle {
    id: root

    property int padding: 8

    color: hover.hovered ? Qt.lighter(_.backgroundColor, 1.1) : _.backgroundColor
    radius: padding
    implicitWidth: delegateContent.width + (2*padding)
    implicitHeight: delegateContent.height + (2*padding)

    states: [
        State {
            name: "create"
            PropertyChanges { target: name; visible: true; focus: true }
            PropertyChanges { target: created; opacity: 1 }
            PropertyChanges { target: actionColumn; visible: true }
            PropertyChanges { target: createIcon; visible: false }
            PropertyChanges { target: placeholder; visible: false }
            // Special case -1 for CreateDelegate.
            StateChangeScript { script: AAnomalyClass.selectRandomColorForClass(-1) }
        }
    ]

    QtObject {
        id: _

        readonly property color backgroundColor: Store.state.anomalyClassOverview.selectedColors[-1] ?? "grey"

        // Resets the delegate into the default state.
        function reset() {
            root.state = ""
            name.text = ""
            AAnomalyClass.deselectColorForClass(-1)
        }
    }

    VCI.Icon {
        id: createIcon

        anchors.centerIn: parent
        name: "plus"
        size: Theme.iconSizeM
        color: "white"
    }

    ColumnLayout {
        id: delegateContent

        anchors.centerIn: parent

        Row {
            TextField {
                id: name

                font.pixelSize: Theme.fontSizeL
                color: L.Color.foregroundOfColor(_.backgroundColor)
                placeholderText: qsTr("Class name") + "..."
                placeholderTextColor: Qt.darker(name.color, 1.15)
                visible: false

                Layout.preferredWidth: 160

                // Shortcut to trigger action by pressing return.
                Keys.onReturnPressed: {
                    if (action.enabled) {
                        action.clicked()
                    }
                }
            }

            VCB.RoundIconButton {
                fontIcon {
                    name: "edit-2"
                    size: Theme.iconSizeXXS
                    color: name.color
                }
                toolTipText: qsTr("Pick color")
                visible: name.visible

                Material.background: Qt.lighter(_.backgroundColor, 1.15)

                // Special case -1 for CreateDelegate.
                onClicked: AAnomalyClass.selectColorForClass(-1)
            }
        }

        Text {
            id: placeholder

            font {
                pixelSize: Theme.fontSizeL
                weight: Font.DemiBold
            }
            text: "dummy"
            opacity: 0

            Layout.preferredWidth: 160
        }

        Text {
            id: created

            font {
                pixelSize: Theme.fontSizeM
            }
            color: name.color
            text: (new Date()).formatDateTime(Store.state.locale)
            opacity: 0
        }
    }

    Column {
        id: actionColumn

        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.right
            leftMargin: 8
        }
        visible: false
        spacing: 8

        VCF.Error {
            id: err

            text: L.Val.anomalyClassName(name.text, Store.state.anomalyClasses, true)
        }

        Row {
            spacing: 8

            VCB.RoundIconButton {
                id: action

                fontIcon {
                    name: "check"
                    size: Theme.iconSizeXXS
                    color: "white"
                }
                enabled: !err.visible && name.text !== ""

                Material.background: Theme.success

                onClicked: {
                    AAnomalyClass.add(name.text, L.Color.qmlColorToJsRGB(_.backgroundColor))
                    _.reset()
                }
            }

            VCB.RoundIconButton {
                fontIcon {
                    name: "x"
                    size: Theme.iconSizeXXS
                    color: "white"
                }

                Material.background: Theme.error

                onClicked: _.reset()
            }
        }
    }

    HoverHandler {
        id: hover

        cursorShape: Qt.PointingHandCursor
    }

    VCH.Tap {
        onTapped: root.state = "create"
    }
}
