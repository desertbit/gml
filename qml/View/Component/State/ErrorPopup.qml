import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

import Action as A
import Lib as L
import Store
import Theme

import View.Component.Button as VCB
import View.Component.Icon as VCI

Popup {
    id: root

    signal confirmed()

    closePolicy: Popup.NoAutoClose
    dim: true
    padding: 0
    modal: true
    // Otherwise, elements underneath can still gain focus.
    focus: true
    // Popup should be as wide as the footer.
    contentWidth: footer.implicitWidth

    background: LinearGradient {
        start: Qt.point(0, 0)
        end: Qt.point(width, height)
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#d45659"}
            GradientStop { position: 0.4; color: "#d45659"}
            GradientStop { position: 1.0; color: "#b43639" }
        }
    }

    Component.onCompleted: confirmed.connect(root.close)

    QtObject {
        id: _

        property int contentPadding: Theme.spacingM
    }

    ColumnLayout {
        anchors.fill: parent

        RowLayout {
            Layout.margins: _.contentPadding

            Text {
                font {
                    pixelSize: Theme.fontSizeXXL
                    weight: Font.DemiBold
                }
                color: "white"
                text: L.State.errTitle(Store.state.nline.stateErr.code)

                Layout.fillWidth: true
            }

            VCI.Icon {
                name: "x-circle"
                size: Theme.fontSizeXXXL
                color: "white"
            }
        }

        Rectangle {
            color: "#000000"
            height: Theme.dividerHeight
            opacity: 0.15

            Layout.fillWidth: true
            Layout.leftMargin: Theme.spacingXXXS
            Layout.rightMargin: Theme.spacingXXXS
        }

        Text {
            font {
                pixelSize: Theme.fontSizeL
                weight: Font.Medium
            }
            color: "white"
            text: L.State.errSubTitle(Store.state.nline.stateErr.code)

            Layout.margins: _.contentPadding
            Layout.fillWidth: true
        }

        GridLayout {
            columns: 2
            columnSpacing: Theme.spacingXS

            Layout.margins: _.contentPadding

            // Row 1
            Text {
                font {
                    pixelSize: Theme.fontSizeL
                    weight: Font.DemiBold
                }
                color: "white"
                text: qsTr("Code:")
            }

            Text {
                font {
                    pixelSize: Theme.fontSizeL
                    weight: Font.Medium
                }
                color: "white"
                text: L.State.fmtErrCode(Store.state.nline.stateErr.code)

                Layout.fillWidth: true
            }

            // Row 2
            Text {
                font {
                    pixelSize: Theme.fontSizeL
                    weight: Font.DemiBold
                }
                color: "white"
                text: qsTr("Message:")

                Layout.alignment: Qt.AlignTop
            }

            Text {
                font {
                    pixelSize: Theme.fontSizeL
                    weight: Font.Medium
                }
                color: "white"
                text: L.State.errDescription(Store.state.nline.stateErr.code, Store.state.nline.stateErr.msg) || "---"
                wrapMode: Text.WordWrap

                Layout.fillWidth: true
            }
        }

        Rectangle {
            id: footer

            color: "white"
            implicitHeight: footerRow.implicitHeight + 2*_.contentPadding
            implicitWidth: footerRow.implicitWidth + 2*_.contentPadding

            Row {
                id: footerRow

                anchors.centerIn: parent
                spacing: Theme.spacingS

                Text {
                    font {
                        pixelSize: Theme.fontSizeL
                        weight: Font.Medium
                    }
                    text: qsTr("Please confirm this message in order to continue using nLine.")
                }

                VCB.Button {
                    id: confirm

                    highlighted: true
                    text: qsTr("Confirm")
                    state: "medium"

                    Material.accent: "#d45659"

                    onClicked: root.confirmed()
                }
            }
        }
    }
}
