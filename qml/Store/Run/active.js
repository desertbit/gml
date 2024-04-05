.pragma library

.import Action as A
.import Lib as L

.import "../conv.js" as Conv

function setFilter(state, data) {
    // Remember which data changed, so we only restart affected streams.
    const eventCodesChanged = !L.Obj.deepEqual(state.runActive.filter.eventCodes, data.eventCodes)
    const timeRangeChanged = state.runActive.filter.timeRange !== data.timeRange
    const timeIntervalChanged = state.runActive.filter.timeInterval !== data.timeInterval

    state.runActive.filter.eventCodes = data.eventCodes
    state.runActive.filter.timeInterval = data.timeInterval

    // If the time range changed, build up the possible values for the time intervals.
    if (timeRangeChanged) {
        state.runActive.filter.timeRange = data.timeRange
        state.runActive.filter.timeIntervals = L.TimeI.model(data.timeRange)
        if (state.runActive.filter.timeIntervals.empty()) {
            console.error("runActive: empty time interval model for time range", data.timeRange)
        } else if (!state.runActive.filter.timeIntervals.includes(state.runActive.filter.timeInterval)) {
            // Check, if the current time interval is still available as on option.
            // If not, simply default to the first one.
            state.runActive.filter.timeInterval = state.runActive.filter.timeIntervals[0]
        }
    }

    state.runActive.maxGraphPoints = state.runActive.filter.timeRange / state.runActive.filter.timeInterval

    // Restart all associated streams, if a run is currently active.
    if (L.State.isRun(state.nline.state)) {
        if (eventCodesChanged) {
            A.ARunActive.unsubscribeEvents(state.runActive.events.callID)
            A.ARunActive.subscribeEvents(state.runActive.product.id, state.runActive.filter.eventCodes, state.runActive.events.max)
        }

        A.ARunActive.unsubscribeAggrEvents(state.runActive.aggrEvents.callID)
        A.ARunActive.subscribeAggrEvents(state.runActive.filter.timeRange, state.runActive.filter.timeInterval, state.runActive.filter.eventCodes)

        if (timeRangeChanged || eventCodesChanged) {
            A.ARunActive.unsubscribeEventDistribution(state.runActive.eventDistribution.callID)
            A.ARunActive.subscribeEventDistribution(state.runActive.filter.timeRange, state.runActive.filter.eventCodes)
        }

        if (state.runActive.enableMeasurement && (timeRangeChanged || timeIntervalChanged)) {
            A.ARunActive.unsubscribeAggrMeasurePoints(state.runActive.aggrMeasurePoints.callID)
            A.ARunActive.subscribeAggrMeasurePoints(state.runActive.filter.timeRange, state.runActive.filter.timeInterval)
        }
    }
}

//--------------------------------------------

function pauseOk(state, data) {
    Conv.runPauseFromGo(data)

    state.runActive.pauses.push(data)
}

//--------------------------------------------

function resumeOk(state, data) {
    Conv.runPauseFromGo(data)

    // Replace the last pause.
    state.runActive.pauses.splice(state.runActive.pauses.length - 1, 1, data)
}

//################//
//### Internal ###//
//################//

function loadOk(state, data) {
    L.Obj.copyFrom(state.runActive, data)

    Conv.runFromGo(state.runActive)
    Conv.runPausesFromGo(state.runActive.pauses)

    // Subscribe to the measurement points, if enabled.
    if (state.runActive.enableMeasurement && L.State.isRun(state.nline.state)) {
        A.ARunActive.subscribeAggrMeasurePoints(state.runActive.filter.timeRange, state.runActive.filter.timeInterval)
    }
}

//--------------------------------------------

function subscribeStats(state, data) {
    state.runActive.stats.callID = data.callID
}

function subscribeStatsUpdate(state, data) {
    L.Obj.copyFrom(state.runActive.stats, data)
}

//--------------------------------------------

function subscribeEvents(state, data) {
    state.runActive.events.callID = data.callID
    state.runActive.events.model = []
}

function subscribeEventsUpdate(state, data) {
    Conv.eventsFromGo(data)

    state.runActive.events.model.unshift(...data)
    if (state.runActive.events.model.length > state.runActive.events.max) {
        // Remove last/oldest event, if maximum has been reached.
        state.runActive.events.model.pop()
    }
}

function subscribeEventsDone(state, data) {
    // Reset.
    state.runActive.events.model = []
}

//--------------------------------------------

function subscribeAggrEvents(state, data) {
    state.runActive.aggrEvents.callID = data.callID
    state.runActive.aggrEvents.changes = []
}

function subscribeAggrEventsUpdate(state, data) {
    Conv.aggrEventsFromGo(data.aggrEvents)

    state.runActive.aggrEvents.changes = data.aggrEvents
}

function subscribeAggrEventsDone(state, data) {
    // Reset.
    state.runActive.aggrEvents.changes = []
}

//--------------------------------------------

function subscribeEventDistribution(state, data) {
    state.runActive.eventDistribution.callID = data.callID
    state.runActive.eventDistribution.model = {}
}

function subscribeEventDistributionUpdate(state, data) {
    state.runActive.eventDistribution.model = data.distribution
}

function subscribeEventDistributionDone(state, data) {
    // Reset.
    state.runActive.eventDistribution.model = {}
}

//--------------------------------------------

function subscribeAggrMeasurePoints(state, data) {
    state.runActive.aggrMeasurePoints.callID = data.callID
    state.runActive.aggrMeasurePoints.model = []
}

function subscribeAggrMeasurePointsUpdate(state, data) {
    Conv.aggrMeasurePointsFromGo(data.points)

    state.runActive.aggrMeasurePoints.model = data.points
}

function subscribeAggrMeasurePointsDone(state, data) {
    state.runActive.aggrMeasurePoints.model = []
}
