.pragma library

.import Dispatcher as D

.import Action.Internal as AInternal

// Sets the filter for the data subscription streams on the run.
// Args:
//  - eventCodes(array) : Contains L.Event.Code elements
//  - timeInterval(int) : The number of seconds of the range to request
//  - timeInterval(int) : The number of seconds to aggregate
function setFilter(eventCodes, timeRange, timeInterval) {
    D.Dispatcher.dispatch(_type(setFilter.name), {
        eventCodes: eventCodes,
        timeRange: timeRange,
        timeInterval: timeInterval
    })
}

// Pauses the run.
function pause() {
    D.Dispatcher.dispatch(_type(pause.name), {})
}

// Resumes the run.
function resume() {
    D.Dispatcher.dispatch(_type(resume.name), {})
}

// Finishes the run.
function finish() {
    D.Dispatcher.dispatch(_type(finish.name), {})
}

//################//
//### Internal ###//
//################//

// Loads the currently active run.
// Ret:
//  - dispatch promise
function load() {
    return D.Dispatcher.dispatch(_type(load.name), {}, true)
}

// Subscribes to updates to the stats of the active run.
function subscribeStats() {
    D.Dispatcher.dispatch(_type(subscribeStats.name), {})
}

// Unsubscribes from updates to the stats of the active run.
// Args:
//  - callID(int) : The callID of the Api stream.
function unsubscribeStats(callID) {
    AInternal.emitCancel(callID)
}

// Subscribes to updates to the events of the active run.
// Args:
//  - productID(int)    : The id of the product
//  - eventCodes(array) : Contains L.Event.Code elements
//  - historySize(int)  : The maximum number of events
function subscribeEvents(productID, eventCodes, historySize) {
    D.Dispatcher.dispatch(_type(subscribeEvents.name), {
        productID: productID,
        eventCodes: eventCodes,
        historySize: historySize
    })
}

// Unsubscribes from updates to the events of the active run.
// Args:
//  - callID(int) : The callID of the Api stream.
function unsubscribeEvents(callID) {
    AInternal.emitCancel(callID)
}

// Subscribes to updates to the aggregated events of the active run.
// The current filter configuration from the state is used.
// Args:
//  - timeRange(int)    : The number of seconds of the range to request
//  - timeInterval(int) : The number of seconds to aggregate
//  - eventCodes(array) : Contains L.Event.Code elements
function subscribeAggrEvents(timeRange, timeInterval, eventCodes) {
    D.Dispatcher.dispatch(_type(subscribeAggrEvents.name), {
        lastSeconds: timeRange,
        intervalSeconds: timeInterval,
        eventCodes: eventCodes
    })
}

// Unsubscribes from updates to the aggregated events of the active run.
// Args:
//  - callID(int) : The callID of the Api stream.
function unsubscribeAggrEvents(callID) {
    AInternal.emitCancel(callID)
}

// Subscribes to updates to the event distribution of the active run.
// The current filter configuration from the state is used.
// Args:
//  - timeRange(int)    : The number of seconds of the range to request
//  - eventCodes(array) : Contains L.Event.Code elements
function subscribeEventDistribution(timeRange, eventCodes) {
    D.Dispatcher.dispatch(_type(subscribeEventDistribution.name), {
        lastSeconds: timeRange,
        eventCodes: eventCodes
    })
}

// Unsubscribes from updates to the event distribution of the active run.
// Args:
//  - callID(int) : The callID of the Api stream.
function unsubscribeEventDistribution(callID) {
    AInternal.emitCancel(callID)
}

// Subscribes to updates to the aggregated measure points of the active run.
// The current filter configuration from the state is used.
// Args:
//  - timeRange(int)    : The number of seconds of the range to request
//  - timeInterval(int) : The number of seconds to aggregate
function subscribeAggrMeasurePoints(timeRange, timeInterval) {
    D.Dispatcher.dispatch(_type(subscribeAggrMeasurePoints.name), {
        lastSeconds: timeRange,
        intervalSeconds: timeInterval
    })
}

// Unsubscribes from updates to the aggregated measure points of the active run.
// Args:
//  - callID(int) : The callID of the Api stream.
function unsubscribeAggrMeasurePoints(callID) {
    AInternal.emitCancel(callID)
}

//###############//
//### Private ###//
//###############//

// Returns the action type for the given function name of this script.
// Ret:
//  - string
function _type(funcName) {
    return "runActive" + funcName.capitalize()
}

