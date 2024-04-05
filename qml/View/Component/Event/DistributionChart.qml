import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtCharts

import Lib as L
import Store
import Theme

import View.Component.Form as VCF

Rectangle {
    id: root

    required property var model

    readonly property bool empty: {
        if (Object.keys(model).empty()) {
            return true
        }
        for (const key in model) {
            if (model[key] > 0) {
                return false
            }
        }
        return true
    }

    // The bottom margin of the chart legend.
    property real legendBottomMargin: 0

    color: Theme.colorBackground
    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    ColumnLayout {
        id: content

        anchors.fill: parent
        spacing: 0

        RowLayout {
            spacing: 0

            // Pie Chart.
            ChartView {
                locale: Qt.locale(Store.state.locale)
                localizeNumbers: true
                legend.visible: false
                antialiasing: true
                visible: !root.empty

                Layout.fillWidth: true
                Layout.fillHeight: true

                PieSeries {
                    size: 1

                    DistributionPieSlice { value: root.model[code.toString()] ?? 0; code: L.Event.Code.Error        }
                    DistributionPieSlice { value: root.model[code.toString()] ?? 0; code: L.Event.Code.Defect       }
                    DistributionPieSlice { value: root.model[code.toString()] ?? 0; code: L.Event.Code.MeasureDrift }
                }
            }

            // Bar Chart
            ChartView {
                locale: Qt.locale(Store.state.locale)
                localizeNumbers: true
                legend.visible: false
                antialiasing: true
                visible: !root.empty

                Layout.fillWidth: true
                Layout.fillHeight: true

                BarSeries {
                    labelsVisible: true
                    axisX: BarCategoryAxis { categories: [ qsTr("#Events") ] }
                    axisY: ValueAxis {
                        readonly property int maxValue: root.empty ? 0 : Math.max(...Object.values(root.model))

                        min: 0
                        // Ensure that the max value is always at least a multiple of the tickCount-1
                        // to get nicely, evenly spaced graph labels.
                        max: maxValue + ((tickCount-1) - (maxValue % (tickCount-1)))
                        tickCount: 5
                        tickType: ValueAxis.TicksFixed
                    }

                    DistributionBarSet { value: root.model[code.toString()] ?? 0; code: L.Event.Code.Error        }
                    DistributionBarSet { value: root.model[code.toString()] ?? 0; code: L.Event.Code.Defect       }
                    DistributionBarSet { value: root.model[code.toString()] ?? 0; code: L.Event.Code.MeasureDrift }
                }
            }

            // No data available label.
            Text {
                text: "- " + qsTr("No data available") + " -"
                color: Theme.colorForegroundTier2
                font {
                    italic: true
                    pixelSize: Theme.fontSizeXL
                }
                visible: root.empty
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter

                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }

        VCF.HorDivider {}

        ChartLegend {
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: root.legendBottomMargin
        }
    }
}
