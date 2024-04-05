import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Lib as L
import Theme
import Store

import View.Component.Form as VCF
import View.Component.Text as VCT

import "../Table"

Base {
    id: root

    RowLayout {
        spacing: Theme.spacingXS

        Table {
            Table.Label { 
                //: The type of the nLine device, e.g. '3M2_30_500v1'
                text: qsTr("Device type") + ":" 
            }
            Table.Text { text: Store.state.nline.devType }

            Table.HorDivider {}

            Table.Label { text: qsTr("Motorized focus") + ":" }
            VCT.ActiveIcon {
                state: Store.state.nline.hasMotorizedFocus ? "" : "inactive"
                icon.size: Theme.iconSizeXS
                label.font.pixelSize: 17
            }
        }

        Table.VerDivider {}

        Table {
            Table.Label {
                //: Abbreviation stands for meter per minute.
                text: qsTr("Speed limits (m/min)")
                
                Layout.columnSpan: parent.columns
            }

            Table.HorDivider {}

            Table.Label { text: qsTr("Mininum") + ":" }
            Table.Text { text: L.LMath.roundToFixed(Store.state.nline.speedLimit.min / 100, 2) }

            Table.HorDivider {}

            Table.Label { text: qsTr("Maximum") + ":" }
            Table.Text { text: L.LMath.roundToFixed(Store.state.nline.speedLimit.max / 100, 2) }
        }

        Table.VerDivider {}

        Table {
            Table.Label {
                //: The hostname of the nLine device, normally the same as the serial number.
                text: qsTr("Hostname") + ":"
            }
            Table.Text { text: Store.state.nline.info.hostname }

            Table.HorDivider {}
        }
    }

    Item { Layout.fillHeight: true } // Filler
}
