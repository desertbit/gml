import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import QtCharts

import Store
import Theme

import View.Component.Container as VCC

VCC.IconPane {
    id: root

    //: The usage of the central processing unit.
    titleText: qsTr("CPU Usage")
    titleIconName: "cpu"

    QtObject {
        id: _

        // For shorter access.
        readonly property var usages: Store.state.nline.stats.cpu.usagePerLogCore
        // The total usage.
        readonly property real total: usages.empty() ? 0 : usages.reduce((acc, val) => acc + val, 0) / usages.length
    }

    ColumnLayout {
        ChartView {
            antialiasing: true
            legend.alignment: Qt.AlignBottom
            locale: Qt.locale(Store.state.locale)

            // Use the maximum available space for the chart view.
            Layout.margins: -Theme.spacingS
            Layout.fillWidth: true
            Layout.fillHeight: true

            BarSeries {
                axisX: BarCategoryAxis {
                    // We construct an array like this -> ["0", "1", "2", "3", "4", "5" ]
                    categories: Array.from(Array(_.usages.length), (_, i) => i.toString())
                }
                axisY: ValueAxis {
                    min: 0
                    max: 100
                    tickCount: 5
                }

                BarSet {
                    //: A logic core is most often a Thread of a CPU.
                    label: qsTr("Logic Core")
                    values: _.usages
                }
            }
        }

        Components.LabRow {
            //: As in the grand total of a sum, for example
            labelText: qsTr("Total:")

            Components.Label {
                text: _.total.toFixed(2) + "%"
            }
        }
    }
}
