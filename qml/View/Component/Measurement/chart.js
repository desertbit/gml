function loadChangesIntoChart(changes, maxPoints) {
    const allSeries = [target, targetMin, targetMax, actual]

    // Clear all points.
    if (maxPoints <= 0) {
        for (const series of allSeries) {
            series.removePoints(0, series.count)
        }
    }

    // Nothing to do, if no changes have been supplied.
    if (changes.empty()) {
        return
    }

    // Add new points.
    for (const p of changes) {
        const ts = p.ts.getTime()

        // Append new data point for target series.
        target.append(ts, root.diameterNorm)
        targetMin.append(ts, root.diameterMin)
        targetMax.append(ts, root.diameterMax)

        // No measuring point available.
        if (p.diameterMax === 0) {
            p.diameterMin = 0
            p.diameterMax = 0
        }

        // Use the worst value of min/max depending on their normalized comparison.
        const minNormalized = Math.abs((root.diameterNorm - p.diameterMin) / (root.diameterNorm - root.diameterMin))
        const maxNormalized = Math.abs((root.diameterNorm - p.diameterMax) / (root.diameterNorm - root.diameterMax))
        const worstValue = maxNormalized > minNormalized ? p.diameterMax : p.diameterMin
        actual.append(ts, Math.round(worstValue*100)/100)
    }

    // Remove the overflow.
    if (maxPoints > 0) {
        for (const series of allSeries) {
            const overflow = series.count - maxPoints
            if (overflow > 0) {
                series.removePoints(0, overflow)
            }
        }
    }

    // Set min and max values.
    // First the date which is the same for all series.
    const count = target.count
    axisX.min = new Date(target.at(0).x)
    axisX.max = new Date(target.at(count-1).x)
    
    // Now search the min and max measurement values.
    let min = root.diameterMin, max = root.diameterMax
    for (let i = 0; i < actual.count; ++i) {
        const targetMinVal = targetMin.at(i).y
        const targetMaxVal = targetMax.at(i).y
        const actualVal = actual.at(i).y

        // Do not adjust min/max values, if the measurement was disabled.
        if (actualVal === 0) {
            continue
        }

        const newMin = Math.min(targetMinVal, targetMaxVal, actualVal)
        const newMax = Math.max(targetMinVal, targetMaxVal, actualVal)

        if (newMin < min) {
            min = newMin
        }
        if (newMax > max) {
            max = newMax
        }
    }
    axisY.minValue = min
    axisY.maxValue = max
}
