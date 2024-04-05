import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import QtCharts

import Store
import Theme

import View.Component.Container as VCC
import View.Component.Form as VCF

VCC.IconPane {
    id: root

    property alias available: available.text
    property alias used: used.text
    property alias usedPct: usedPct.value
    property alias subtitle: subtitle.text

    titleRightContent: Text {
        id: subtitle

        font {
            pixelSize: Theme.fontSizeM
            weight: Font.Medium
        }
        visible: !!text
    }
    spacing: 0

    ChartView {
        legend.visible: false
        antialiasing: true
        locale: Qt.locale(Store.state.locale)

        // Use the maximum available space for the chart view.
        Layout.margins: -Theme.spacingS
        Layout.fillWidth: true
        Layout.fillHeight: true

        PieSeries {
            PieSlice {
                id: usedPct

                label: value.toFixed(2) + "%"
                value: 100
                color: value > 90 ? Theme.error :
                       value > 70 ? Theme.warning :
                                    Theme.success
                labelVisible: true
            }
            PieSlice {
                label: value.toFixed(2) + "%"
                value: 100 - root.usedPct
                color: "#EFEFEF"

                labelVisible: true
            }
        }
    }

    RowLayout {
        spacing: 0

        Components.LabRow {
            //: As in how many resources are available currently.
            labelText: qsTr("Available:")

            Components.Label {
                id: available

                Layout.fillWidth: true
            }
        }

        Components.LabRow {
            //: As in how many resources are used currently.
            labelText: qsTr("Used:")

            Components.Label {
                id: used
            }
        }
    }
}
