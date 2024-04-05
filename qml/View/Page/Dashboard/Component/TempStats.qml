import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtCharts

import Store
import Theme

import View.Component.Container as VCC

import "tempStats.js" as Logic

VCC.IconPane {
    id: root

    //: The temperature of the central processing unit / graphics processing unit.
    titleText: qsTr("Temperature")
    titleIconName: "thermometer"

    Connections {
        target: Store.state.nline.stats.temps

        function onReadingsChanged() {
            Logic.loadTemps(Store.state.nline.stats.temps.readings)
        }
    }

    ColumnLayout {
        ChartView {
            id: chart

            legend.alignment: Qt.AlignBottom
            antialiasing: true
            locale: Qt.locale(Store.state.locale)
            localizeNumbers: true
            visible: !noDataLabel.visible

            // Use the maximum available space for the chart view.
            Layout.margins: -Theme.spacingS
            Layout.fillWidth: true
            Layout.fillHeight: true

            DateTimeAxis {
                id: axisX

                tickCount: 5
                format: qsTr("dd/MM/yyyy") + "-hh:mm:ss"
                titleText: qsTr("Time")
            }

            ValueAxis {
                id: axisY

                min: 20
                max: 100
                //: The temperature in degree celcius.
                titleText: qsTr("Temp (°C)")
            }
        }

        Text {
            id: noDataLabel

            color: Theme.colorForegroundTier2
            font {
                pixelSize: Theme.fontSizeXL
                italic: true
            }
            text: qsTr("Not enough data yet available")
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter

            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
