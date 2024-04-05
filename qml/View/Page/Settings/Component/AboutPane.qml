import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action.App as AApp

import Store
import Theme

import View.Component.Container as VCC
import View.Component.Form as VCF
import View.Component.Handler as VCH

VCC.IconPane {
    id: root

    titleText: qsTr("About")
    titleIconName: "help-circle"
    titleIconColor: Material.color(Material.Green)
    contentSpacing: Theme.spacingS

    VCF.LabeledColumnLayout {
        labelText: qsTr("Versions")
        label.font.pixelSize: Theme.fontSizeL

        Layout.alignment: Qt.AlignTop

        GridLayout {
            columns: 2
            columnSpacing: Theme.spacingXXS

            component GridLabel: Text {
                font.pixelSize: Theme.fontSizeM
            }

            component GridText: Text {
                font.pixelSize: Theme.fontSizeM
                horizontalAlignment: TextInput.AlignRight

                Layout.fillWidth: true
            }

            // Long press tap handler to show advanced options for power users.
            VCH.Tap {
                // Give slightly bigger area for detecting taps.
                margin: 10
                longPressThreshold: 5

                onLongPressed: AApp.showAdvancedOptions()
            }

            GridLabel { text: "nVision:" }
            GridText { text: Qt.application.version }

            GridLabel { text: "nLine:" }
            GridText { text: Store.state.nline.nlineVersion }

            GridLabel { text: "Backend:" }
            GridText { text: Store.state.nline.backendVersion }
        }
    }

    RowLayout {
        Text {
            font {
                italic: true
                pixelSize: Theme.fontSizeM
            }
            text: qsTr("Copyright © nLine GmbH")

            Layout.fillWidth: true
        }

        Text {
            font {
                italic: true
                pixelSize: Theme.fontSizeS
            }
            text: qsTr("Powered by Wahtari GmbH")
        }
    }
}
