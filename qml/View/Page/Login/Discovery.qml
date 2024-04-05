import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

import Theme
import Store

import View.Component.Container as VCC
import View.Component.Logo as VCL
import View.Component.Text as VCT

import "Component"

VCC.Page {
    id: root

    title: qsTr("Login")

    ColumnLayout {
        anchors {
            fill: parent
            margins: Theme.spacingL
        }
        spacing: Theme.spacingL

        VCL.Banner {}

        VCT.PaneLabel {
            text: qsTr("Choose a nLine device to connect to.\nYou can select one from the list of discovered devices, or enter a custom address manually.")
            font {
                pixelSize: Theme.fontSizeL
            }
        }

        RowLayout {
            spacing: Theme.spacingL

            DiscoveryPane {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            CustomAddressPane {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }
}
