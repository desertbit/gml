.import Lib as L

function loadChangesIntoChart(changes, maxPoints) {
    //console.time(`loadModelIntoChart ${changes.length}`)

    // Check that the series are already loaded.
    let abort = false
    L.Event.forEachCode(code => {
        if (!chart.series(L.Event.codeName(code))) {
            abort = true
        }
    })
    if (abort) {
        return
    }

    // Clear all points.
    if (maxPoints <= 0) {
        L.Event.forEachCode(code => {
            const series = chart.series(L.Event.codeName(code))
            series.removePoints(0, series.count)
        })
    }

    // Nothing to do, if no changes have been supplied.
    if (changes.empty()) {
        return
    }

    // Add new points.
    //console.time("loadModelIntoChart - 1")
    for (const p of changes) {
        const ts = p.ts.getTime()

        // Iterate over all event codes and retrieve their count.
        // If it is not defined, default to 0.
        L.Event.forEachCode(code => {
            const series = chart.series(L.Event.codeName(code))
            const codeStr = code.toString()
            const count = p.countByCode.hasOwnProperty(codeStr) ? p.countByCode[codeStr] : 0
            series.append(ts, count)
        })
    }
    //console.timeEnd("loadModelIntoChart - 1")

    //console.time("loadModelIntoChart - 2")
    let yMax = 0
    L.Event.forEachCode(code => {
        const series = chart.series(L.Event.codeName(code))

        // Remove the overflow.
        if (maxPoints > 0) {
            const overflow = series.count - maxPoints
            if (overflow > 0) {
                series.removePoints(0, overflow)
            }
        }

        // Find the maximum y value across all series.
        for (let i = 0; i < series.count; ++i) {
            const y = series.at(i).y
            if (y > yMax) {
                yMax = y
            }
        }
    })
    //console.timeEnd("loadModelIntoChart - 2")

    // Ensure that the max value is always at least a multiple of the tickCount-1
    // to get nicely, evenly spaced graph labels.
    axisY.max = yMax + ((axisY.tickCount-1) - (yMax % (axisY.tickCount-1)))

    // Set min and max date, which equal the first and last datapoint.
    const s = chart.series(0)
    axisX.min = new Date(s.at(0).x)
    axisX.max = new Date(s.at(s.count - 1).x)
    //console.timeEnd(`loadModelIntoChart ${changes.length}`)
}

function showToolTip(p, code) {
    if (!root.enableToolTip) {
        return
    }

    let mapped = chart.mapToPosition(p)
    chart.selectedCode = code
    toolTipText.text = qsTr("Num events: %1").arg(Math.round(p.y))
    chart.selectedTS = Number(p.x.toFixed(0))
    toolTip.x = mapped.x
    toolTip.y = mapped.y - toolTip.height
    toolTip.visible = true
}

function toolTipFilterClicked() {
    toolTip.visible = false

    // Find bounds of the bucket.
    const endTime = new Date(root.changes.last().ts).getTime()
    const startTime = new Date(root.changes[0].ts).getTime()
    const interval = (endTime - startTime) / (root.changes.length-1)
    root.pointSelected([chart.selectedCode], new Date(chart.selectedTS-interval), new Date(chart.selectedTS))
}
