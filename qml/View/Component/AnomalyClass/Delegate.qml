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
import View.Component.Icon as VCI
import View.Component.List as VCL

Item {
    id: root

    required property var modelData  // Model.AnomalyClass
    required property int index

    property int padding: 8

    // If true, the delegate offers the edit controls upon tap.
    property bool editable: false
    // If true, the lock icon is displayed.
    property alias showLockIcon: icon.visible
    // The font size of the name.
    property alias nameFontPixelSize: name.font.pixelSize

    // If true, the delegate emits the selected and deselected signals.
    property bool canSelect
    // True, if the delegate is currently selected.
    property bool isSelected: false
    // Should be true, when a selection is currently active.
    // The delegate will then emit selected and deselected instead
    // of tapped signals, when the user clicks anywhere on the delegate.
    property bool selectionMode: false

    // Emitted when the user selects the delegate via the checkbox.
    signal selected(int id)
    // Emitted when the user deselects the delegate via the checkbox.
    signal deselected(int id)

    implicitWidth: content.implicitWidth + (state === "edit" ? _.actionWidth : 0) + (2*padding)
    implicitHeight: Math.max(content.implicitHeight, (state === "edit" ? actionColumn.implicitHeight : 0)) + (2*padding)

    // While the selection mode is active, it must not be possible to also edit a class.
    onSelectionModeChanged: {
        if (selectionMode && state === "edit") {
            state = ""
        }
    }

    states: [
        State {
            name: "edit"
            PropertyChanges { target: edit; visible: true; focus: true }
            PropertyChanges { target: nameRow; visible: false }
            PropertyChanges { target: actionColumn; visible: true }
        }
    ]

    QtObject {
        id: _

        readonly property real actionWidth: actionColumn.implicitWidth + actionColumn.anchors.leftMargin
        readonly property color backgroundColor: Store.state.anomalyClassOverview.selectedColors[root.modelData.id] ?? root.modelData.color
    }

    VCL.SelectionTapHandler {
        anchors.fill: background
        selectionMode: root.selectionMode && root.canSelect
        isSelected: root.isSelected
        canSelect: root.canSelect

        onSelected: root.selected(root.modelData.id)
        onDeselected: root.deselected(root.modelData.id)
        onTapped: {
            if (root.editable) {
                root.state = "edit"
            }
        }
    }

    Rectangle {
        id: background

        anchors {
            margins: -root.padding
            fill: content
        }

        color: hover.hovered ? Qt.lighter(_.backgroundColor, 1.1) : _.backgroundColor
        radius: padding
    }

    ColumnLayout {
        id: content

        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
        }

        Row {
            id: nameRow

            spacing: 8

            Text {
                id: name

                anchors.verticalCenter: parent.verticalCenter
                font {
                    pixelSize: Theme.fontSizeL
                    weight: Font.DemiBold
                }
                color: L.Color.foregroundOfColor(_.backgroundColor)
                text: L.Tr.anomalyClass(root.modelData.id, root.modelData.name)
            }

            VCI.Icon {
                id: icon

                anchors.verticalCenter: parent.verticalCenter
                name: "lock"
                size: Theme.iconSizeXXS
                color: name.color
                visible: false
            }
        }

        Row {
            TextField {
                id: edit

                font.pixelSize: Theme.fontSizeL
                color: L.Color.foregroundOfColor(_.backgroundColor)
                placeholderText: qsTr("Class name") + "..."
                placeholderTextColor: Qt.darker(name.color, 1.15)
                visible: false
                text: name.text

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
                visible: edit.visible

                Material.background: Qt.lighter(_.backgroundColor, 1.15)

                onClicked: AAnomalyClass.selectColorForClass(root.modelData.id)
            }
        }

        Text {
            id: created

            font {
                pixelSize: Theme.fontSizeM
            }
            color: name.color
            text: root.modelData.created.formatDateTime(Store.state.locale)
        }
    }

    Column {
        id: actionColumn

        anchors {
            verticalCenter: parent.verticalCenter
            left: content.right
            leftMargin: 16
        }
        visible: false
        spacing: 8

        VCF.Error {
            id: err

            // Filter out our class, as it will match its own name and cause an error.
            text: L.Val.anomalyClassName(edit.text, Store.state.anomalyClasses.filter(ac => ac.id !== root.modelData.id), true)
        }

        RowLayout {
            spacing: 8

            VCB.RoundIconButton {
                id: action

                fontIcon {
                    name: "check"
                    size: Theme.iconSizeXXS
                    color: "white"
                }
                enabled: !err.visible && edit.text !== ""
                         && (edit.text !== root.modelData.name || _.backgroundColor.toString() !== root.modelData.color.toString())

                Material.background: Theme.success

                onClicked: {
                    AAnomalyClass.edit(root.modelData.id, edit.text, L.Color.qmlColorToJsRGB(_.backgroundColor))
                    root.state = ""
                }
            }

            VCB.RoundIconButton {
                fontIcon {
                    name: "x"
                    size: Theme.iconSizeXXS
                    color: "white"
                }

                Material.background: Theme.error

                onClicked: {
                    AAnomalyClass.deselectColorForClass(root.modelData.id)
                    root.state = ""
                }
            }
        }
    }

    VCL.SelectionOverlay {
        anchors.fill: background
        radius: background.radius
        visible: root.selectionMode && root.canSelect
        selected: parent.isSelected
    }

    HoverHandler {
        id: hover

        cursorShape: Qt.PointingHandCursor
    }
}
