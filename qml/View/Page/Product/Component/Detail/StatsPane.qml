import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtCharts

import Action.ProductDetail as AProductDetail

import Lib as L
import Store
import Theme

import View.Component.Container as VCC

VCC.IconPane {
    id: root

    titleText: qsTr("Statistics")
    titleIconName: "bar-chart-2"
    titleIconColor: Material.color(Material.Orange)
    titleRightContentSpacing: Theme.spacingS
    titleRightContent: [
        Text {
            text: qsTr("Max batches shown:")
            font.pixelSize: Theme.fontSizeM
        },
        ComboBox {
            id: limit

            function _elem(v) {
                return {text: `${v}`, value: v}
            }

            textRole: "text"
            valueRole: "value"
            model: [
                _elem(5),
                _elem(10),
                _elem(25),
                _elem(50),
                _elem(100),
                {text: qsTr("All"), value: 0},
            ]
            currentIndex: 2

            onActivated: AProductDetail.loadRecentRunsNumEvents(Store.state.productDetail.id, limit.currentValue)
        }
    ]

    // This item fixes a weird UI bug, the chart only occupies half of the available height.
    Item {
        Layout.fillWidth: true
        Layout.fillHeight: true

        ChartView {
            id: chart

            anchors.fill: parent
            locale: Qt.locale(Store.state.locale)
            localizeNumbers: true
            legend.visible: false
            antialiasing: true
            // We need at least two data points for the graph to be displayed.
            visible: Store.state.productDetail.recentRunsNumEvents.length > 1
            margins.top: 0
            margins.left: 0
            margins.bottom: 6 // Margin for the x axis labels.
            //margins.right: -1 // Fixes LineSeries point bleeding onto the root Panel.

            ValueAxis {
                id: axisY

                min: 0
                max: {
                    const max = Math.max(...Store.state.productDetail.recentRunsNumEvents)
                    if (!isFinite(max)) {
                        return 0
                    }
                    // Ensure that the max value is always at least a multiple of the tickCount-1
                    // to get nicely, evenly spaced graph labels.
                    return max + ((tickCount-1) - (max % (tickCount-1)))
                }
                minorTickCount: 1
                tickCount: 5
                tickType: ValueAxis.TicksFixed
                //: The number of errors.
                titleText: qsTr("Number of events")
                // BUG: Normally, something like "%.0f" or "%d" should suffice to format the labels without decimal places.
                // But when we set such a label format, the labels are elided when they have 3 or more digits.
                //labelFormat: "%d"
            }

            LineSeries {
                id: numEvents

                axisX: ValueAxis {
                    visible: false
                    max: Store.state.productDetail.recentRunsNumEvents.length-1
                }
                axisY: axisY
                pointsVisible: true
            }

            Connections {
                target: Store.state.productDetail

                function onRecentRunsNumEventsChanged() {
                    numEvents.clear()
                    Store.state.productDetail.recentRunsNumEvents.forEach((num, i) => numEvents.append(i, num))
                }
            }

            RowLayout {
                anchors {
                    left: chart.left
                    leftMargin: chart.plotArea.x
                    bottom: chart.bottom
                    right: chart.right
                }

                Text { text: Store.state.productDetail.recentRunsNumEventsOldestTS.formatDateTime(Store.state.locale) }
                Text {
                    text: qsTr("Last %L1 batch(es)").arg(Store.state.productDetail.recentRunsNumEvents.length)
                    horizontalAlignment: Qt.AlignHCenter
                    font: axisY.titleFont

                    Layout.fillWidth: true
                }
                Text { text: Store.state.productDetail.recentRunsNumEventsNewestTS.formatDateTime(Store.state.locale) }
            }
        }
    }

    // Shows a message if no run is available yet.
    Text {
        font.pixelSize: Theme.fontSizeXL
        color: Theme.colorForegroundTier2
        text: "- " + qsTr("Not enough batches available") + " -"
        visible: !chart.visible
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter

        Layout.fillWidth: true
        Layout.fillHeight: true
    }
}
