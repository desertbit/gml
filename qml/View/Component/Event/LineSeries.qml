import QtCharts as QC

import Lib as L

QC.LineSeries {
    // The associated scatter series, which defines axis, code, etc.
    property ScatterSeries scatter

    axisX: scatter.axisX
    axisY: scatter.axisY
    color: scatter.color
    name: L.Event.codeName(scatter.code)
    visible: count > 0

    onPointAdded: index => {
        const p = this.at(index)
        scatter.append(p.x, p.y)
    }
    onPointsRemoved: (index, count) => scatter.removePoints(index, count)
}
