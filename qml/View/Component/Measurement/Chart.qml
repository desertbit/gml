import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtCharts
import Action as A
import Lib as L
import Store
import Theme

import "chart.js" as Logic

// The measurement graph contains a chart view that draws aggregated measure points.
Item {
    id: root

    required property var changes
    required property int maxPoints
    required property real diameterNorm
    required property real diameterMin
    required property real diameterMax

    property alias showPointLabels: actual.pointLabelsVisible

    // Returns true, if the graph has no maxPoints set and its changes are empty.
    // If maxPoints is set, this is never true.
    readonly property bool empty: maxPoints <= 0 && changes.empty()

    implicitWidth: chart.implicitWidth
    implicitHeight: chart.implicitHeight

    onChangesChanged: Logic.loadChangesIntoChart(changes, maxPoints)

    ChartView {
        id: chart

        anchors.fill: parent
        locale: Qt.locale(Store.state.locale)
        localizeNumbers: true
        legend {
            alignment: Qt.AlignBottom
            markerShape: Legend.MarkerShapeCircle
            visible: root.visible
        }
        antialiasing: true
        margins.right: 0
        margins.top: unitLabel.implicitHeight
        visible: !root.empty

        DateTimeAxis {
            id: axisX

            tickCount: 5
            format: qsTr("dd/MM/yyyy") + "-hh:mm:ss"
        }

        ValueAxis {
            id: axisY

            property real minValue: 0
            property real maxValue: 0

            // Give some padding around the min/max values.
            readonly property real padding: (maxValue - minValue) / 2

            min: minValue - padding
            max: maxValue + padding
            minorTickCount: 1
            tickCount: 5
            tickType: ValueAxis.TicksFixed
        }

        LineSeries {
            id: target

            axisX: axisX
            axisY: axisY
            color: "green"
            name: qsTr("Target")
            width: 2
        }

        LineSeries {
            id: targetMin

            axisX: axisX
            axisY: axisY
            color: "red"
            name: qsTr("Min")
            width: 2
        }

        LineSeries {
            id: targetMax

            axisX: axisX
            axisY: axisY
            color: "red"
            name: qsTr("Max")
            width: 2
        }

        LineSeries {
            id: actual

            color: "blue"
            name: qsTr("Measurement")
            pointsVisible: true
            pointLabelsFormat: "@yPoint"
            axisX: axisX
            axisY: axisY
        }
    }

    // Label for the unit of the whole chart (top right)
    Text {
        id: unitLabel

        text: qsTr("Unit: millimeters")
        font.weight: Font.DemiBold
        font.pixelSize: Theme.fontSizeS
        x: parent.width - implicitWidth - 20
        y: 10
        visible: !root.empty
    }

    // Y axis labels.
    ChartYLabel { series: targetMax; chartPlotArea: chart.plotArea; visible: !root.empty } // Label for the upper limit (y axis)
    ChartYLabel { series: targetMin; chartPlotArea: chart.plotArea; visible: !root.empty } // Label for the lower limit (y axis)
    ChartYLabel { series: target;    chartPlotArea: chart.plotArea; visible: !root.empty } // Label for the target diameter (y axis)

    // No data available label.
    Text {
        anchors.fill: parent
        text: "- " + qsTr("No data available") + " -"
        color: Theme.colorForegroundTier2
        font {
            italic: true
            pixelSize: Theme.fontSizeXL
        }
        visible: root.empty
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter
    }
}
