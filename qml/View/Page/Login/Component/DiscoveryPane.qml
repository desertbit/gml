import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

import Theme
import Store

import View.Component.Container as VCC
import View.Component.Icon as VCI

VCC.IconPane {
    titleText: qsTr("nLine devices")
    titleRightContentSpacing: 5
    titleIconName: "search"
    titleIconColor: Material.color(Material.Green)
    title.font.pixelSize: Theme.fontSizeL
    title.horizontalAlignment: Text.AlignHCenter
    separator.color: Theme.colorSeparator

    DiscoveryDeviceList {
        model: Store.state.loginDiscovery.devices

        Layout.fillWidth: true
        Layout.fillHeight: true
    }

    RowLayout {
        VCI.Icon {
            name: "info"
            size: Theme.fontSizeM
        }

        Text {
            text: qsTr("Firewalls may disrupt automatic discovery!")
            font {
                pixelSize: Theme.fontSizeM
                italic: true
            }
            wrapMode: Text.WordWrap

            Layout.fillWidth: true
        }

        BusyIndicator {
            running: Store.view.discoveryActive

            Layout.preferredHeight: scanLabel.height + 5
            Layout.preferredWidth: height
        }

        Text {
            id: scanLabel

            text: qsTr("Scanning local network...")
            color: Theme.colorForegroundTier2
            font.pixelSize: Theme.fontSizeM
        }
    }
}
