import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtCharts
import Action as A
import Lib as L

// A label floating at the label position of the y axis, showing the
// last value of the associated line series.
// Used to show a persistent label for our constant target graphs so that
// users can quickly see the correct y value.
//
// This component sets its position manually via its x,y properties.
// It must be in the same coordinate space as the ChartView containing
// the series this label is attached to.
//
// The color of the label is the same as its series.
Label {
    id: root

    // The series the label should be attached to.
    required property LineSeries series
    // The plot area of the chart.
    required property rect chartPlotArea

    // The first point of the series or 0.
    readonly property point p: series.count > 0 ? series.at(0) : "0,0"

    // Position the label just slightly to the left of the y axis.
    x: chartPlotArea.x - implicitWidth - leftPadding
    y: {
        // Check to prevent a binding loop when the series is not yet filled.
        if (series.count === 0) {
            return 0
        }

        // The relative position of p.y (value between 0 - 1).
        // Must be inverted since the max value is at the origin.
        const pyRel = 1 - ((p.y - series.axisY.min) / (series.axisY.max - series.axisY.min))
        // The absolute position of p.y in relation to the chart.
        const yAbs = (chartPlotArea.height * pyRel) + chartPlotArea.y
        // Position the label vertically centered to the line series.
        return yAbs - (implicitHeight/2)
    }
    background: Rectangle {
        color: root.series.color
        radius: 5
    }
    font.weight: Font.DemiBold
    padding: 4
    color: "white"
    text: L.LMath.roundToFixed(p.y, L.Con.MeasDec)
    // Do not show labels if point is (0,0), preventing jumping labels while data is still being loaded.
    visible: p.x !== 0 || p.y !== 0
}
