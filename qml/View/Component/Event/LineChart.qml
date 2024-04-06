import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtCharts
import Action as A
import Lib as L
import Store
import Theme

import View.Component.Button as VCB

// Import our Line and ScatterSeries.
import "."

import "lineChart.js" as Logic

// The error graph draws a line series per event code containing the number of
// aggregated events from the graph model.
//
// The shown graphs can be filtered using the filterEventCode property.
Rectangle {
    id: root

    required property var changes
    required property int maxPoints

    // If true, tapping or hovering a point in the chart shows the tooltip.
    property bool enableToolTip: false
    // The bottom margin of the chart legend.
    property real legendBottomMargin: 0
    // The size of graph points.
    property real scatterSize: 10

    // Returns true, if the graph has no maxPoints set and its changes are empty.
    // If maxPoints is set, this is never true.
    readonly property bool empty: maxPoints <= 0 && changes.empty()

    // Emitted when a point is selected.
    signal pointSelected(var codes, var afterTS, var beforeTS)

    color: Theme.colorBackground
    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    onChangesChanged: Logic.loadChangesIntoChart(changes, root.maxPoints)

    ColumnLayout {
        id: content

        anchors.fill: parent
        spacing: 0

        ChartView {
            id: chart

            // The code of the selected chart point.
            property int selectedCode: 0
            property real selectedTS: 0

            locale: Qt.locale(Store.state.locale)
            localizeNumbers: true
            legend.visible: false
            antialiasing: true
            visible: !root.empty

            Layout.fillWidth: true
            Layout.fillHeight: true

            DateTimeAxis {
                id: axisX

                tickCount: 5
                titleText: qsTr("Time")
            }

            ValueAxis {
                id: axisY

                min: 0
                minorTickCount: 1
                tickCount: 5
                tickType: ValueAxis.TicksFixed
                //: The number of errors.
                titleText: qsTr("#Errors")
            }

            // The LineSeries will automatically append added points to the Scatter as well!
            LineSeries { scatter: scatterError;     }
            LineSeries { scatter: scatterDefect;    }
            LineSeries { scatter: scatterMeasDrift; }

            ScatterSeries { id: scatterError;     axisX: axisX; axisY: axisY; size: root.scatterSize; code: L.Event.Code.Error;        onClicked: Logic.showToolTip(point, code) }
            ScatterSeries { id: scatterDefect;    axisX: axisX; axisY: axisY; size: root.scatterSize; code: L.Event.Code.Defect;       onClicked: Logic.showToolTip(point, code) }
            ScatterSeries { id: scatterMeasDrift; axisX: axisX; axisY: axisY; size: root.scatterSize; code: L.Event.Code.MeasureDrift; onClicked: Logic.showToolTip(point, code) }

            ToolTip {
                id: toolTip

                enabled: root.enableToolTip

                exit: Transition {
                    NumberAnimation {
                        target: toolTip
                        property: "opacity"
                        easing.type: Easing.InOutQuad
                        from: 1
                        to: 0
                        duration: 100
                    }
                }

                enter: Transition {
                    NumberAnimation {
                        target: toolTip
                        property: "opacity"
                        easing.type: Easing.InOutQuad
                        from: 0
                        to: 1
                        duration: 100
                    }
                }

                background: Rectangle {
                    border.color: L.Event.codeColor(chart.selectedCode)
                    radius: 4
                }

                contentItem: RowLayout {
                    spacing: Theme.spacingXS

                    Text {
                        id: toolTipText

                        font.pixelSize: Theme.fontSizeM
                    }

                    VCB.RoundIconButton {
                        flat: true
                        fontIcon {
                            size: Theme.fontSizeXL
                            color: Theme.colorForeground
                            name: "filter"
                        }

                        onClicked: Logic.toolTipFilterClicked()

                        // The icon inside the button is, due to its height, slightly below the button's center.
                        // Add a minimal margin to center it.
                        Layout.bottomMargin: 4
                        Layout.preferredHeight: toolTipText.height
                        Layout.preferredWidth: height
                    }
                }
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

        Rectangle {
            color: Theme.colorSeparator

            Layout.preferredHeight: 2
            Layout.fillWidth: true
            Layout.bottomMargin: Theme.spacingXS
        }

        ChartLegend {

            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: root.legendBottomMargin
        }
    }
}
