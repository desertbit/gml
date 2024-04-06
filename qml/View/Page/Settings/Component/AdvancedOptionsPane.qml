import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts


import Store
import Theme

import View.Component.Button as VCB
import View.Component.Container as VCC

VCC.IconPane {
    id: root

    titleText: qsTr("Advanced options")
    titleIconName: "flag"
    titleIconColor: Material.color(Material.Red)
    contentSpacing: Theme.spacingS

    titleRightContent: VCB.Button {
        text: qsTr("Hide")

        onClicked: A.AApp.hideAdvancedOptions()
    }

    QtObject {
        id: _

        function update() {
            A.AApp.setAdvancedOptions(fullscreenMode.checked, withVirtualKeyboard.checked, withStorageDevices.checked, devMode.checked)
        }
    }

    ColumnLayout {
        Layout.fillWidth: true

        RowLayout {
            Label {
                font.pixelSize: Theme.fontSizeL
                text: qsTr("Fullscreen mode")
            }

            Item { Layout.fillWidth: true }

            Switch {
                id: fullscreenMode

                text: checked ? qsTr("On") : qsTr("Off")
                font.pixelSize: Theme.fontSizeL
                checked: Store.state.app.opts.fullscreenMode

                onToggled: _.update()
            }
        }

        RowLayout {
            Label {
                font.pixelSize: Theme.fontSizeL
                text: qsTr("Virtual keyboard")
            }

            Item { Layout.fillWidth: true }

            Switch {
                id: withVirtualKeyboard

                text: checked ? qsTr("On") : qsTr("Off")
                font.pixelSize: Theme.fontSizeL
                checked: Store.state.app.opts.withVirtualKeyboard

                onToggled: _.update()
            }
        }

        RowLayout {
            Label {
                font.pixelSize: Theme.fontSizeL
                text: qsTr("Storage devices")
            }

            Item { Layout.fillWidth: true }

            Switch {
                id: withStorageDevices

                text: checked ? qsTr("On") : qsTr("Off")
                font.pixelSize: Theme.fontSizeL
                checked: Store.state.app.opts.withStorageDevices

                onToggled: _.update()
            }
        }

        RowLayout {
            Label {
                font.pixelSize: Theme.fontSizeL
                text: qsTr("Developer mode")
            }

            Item { Layout.fillWidth: true }

            Switch {
                id: devMode

                text: checked ? qsTr("On") : qsTr("Off")
                font.pixelSize: Theme.fontSizeL
                checked: Store.state.app.opts.devMode

                onToggled: _.update()
            }
        }
    }
}
