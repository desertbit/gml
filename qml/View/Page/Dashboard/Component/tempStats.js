function loadTemps(readings) {
    if (readings.count === 0 || readings[0].values.length < 2) {
        return
    }

    readings.forEach(function(r) {
        // Create the series, if it does not exist yet.
        let series = chart.series(r.label)
        if (!series) {
            series = chart.createSeries(ChartView.SeriesTypeLine, r.label, axisX, axisY)
        }

        // Clear it.
        series.removePoints(0, series.count)

        // Add the new points.
        r.values.forEach(v => series.append(v.ts.getTime(), v.value))
    })

    // Set min and max values on the axis.
    // We can use any series here.
    if (chart.count > 0) {
        let s = chart.series(0)
        axisX.min = new Date(s.at(0).x)
        axisX.max = new Date(s.at(s.count-1).x)
    }

    noDataLabel.visible = false
}
