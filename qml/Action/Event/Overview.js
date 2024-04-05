.pragma library

.import Dispatcher as D
.import Lib as L

// View the event overview page coming from the product detail page.
// Args:
//  - productID(int)  : The id of the product
//  - runID(int)      : The id of the run
function viewFromProductDetail(productID, runID) {
    D.Dispatcher.dispatch(_type(viewFromProductDetail.name), {
        productID: productID,
        runID: runID,
        viewState: L.Con.EventOverviewState.List
    })
}

// View the event overview page coming from the run overview page.
// Args:
//  - productID(int)  : The id of the product
//  - runID(int)      : The id of the run
function viewFromRunOverview(productID, runID) {
    D.Dispatcher.dispatch(_type(viewFromRunOverview.name), {
        productID: productID,
        runID: runID,
        viewState: L.Con.EventOverviewState.List
    })
}

// View the event overview page coming from the run detail page.
// Args:
//  - productID(int)  : The id of the product
//  - runID(int)      : The id of the run
//  - viewState(enum) : The state of the view, see L.Con.EventOverviewState
function viewFromRunDetail(productID, runID, viewState) {
    D.Dispatcher.dispatch(_type(viewFromRunDetail.name), {
        productID: productID,
        runID: runID,
        viewState: viewState
    })
}

// View the event overview page coming from the run recent overview page.
// Args:
//  - productID(int)  : The id of the product
//  - runID(int)      : The id of the run
function viewFromRunRecentOverview(productID, runID) {
    D.Dispatcher.dispatch(_type(viewFromRunRecentOverview.name), {
        productID: productID,
        runID: runID,
        viewState: L.Con.EventOverviewState.List
    })
}

// View the event overview page of the active run coming from the status page.
function viewFromStatus() {
    D.Dispatcher.dispatch(_type(viewFromStatus.name), {
        viewState: L.Con.EventOverviewState.List
    })
}

// Sets the filter on the event overview page.
// Causes the data that depends on the filter to be reloaded.
// Args:
//  - afterTS(date)               : The after timestamp to filter by
//  - beforeTS(date)              : The before timestamp to filter by
//  - eventCodes(array)           : The event codes to filter by
//  - anomalyClassIDs(array|null) : The anomaly class ids to filter by, or null if it should be ignored
//  - timeInterval(int)           : The number of seconds to aggregate (for charts)
function setFilter(afterTS, beforeTS, eventCodes, anomalyClassIDs, timeInterval) {
    D.Dispatcher.dispatch(_type(setFilter.name), {
        afterTS: afterTS,
        beforeTS: beforeTS,
        eventCodes: eventCodes,
        anomalyClassIDs: anomalyClassIDs,
        timeInterval: timeInterval
    })
}

// Sets the limit on the page size to requset for the list data.
// Args:
//  - limit(int) : The page size of the list pagination
function setListLimit(limit) {
    D.Dispatcher.dispatch(_type(setListLimit.name), { limit: limit })
}

// Loads the first page of the run's events.
// The filter currently stored in the state is used.
function loadListFirstPage() {
    D.Dispatcher.dispatch(_type(loadListFirstPage.name), {})
}

// Loads the next page of the run's events.
// The filter currently stored in the state is used.
function loadListNextPage() {
    D.Dispatcher.dispatch(_type(loadListNextPage.name), {})
}

// Loads the previous page of the run's events.
// The filter currently stored in the state is used.
function loadListPrevPage() {
    D.Dispatcher.dispatch(_type(loadListPrevPage.name), {})
}

//################//
//### Internal ###//
//################//

// Loads the events for the list.
// Args:
//  - runID(int)             : The id of the run
//  - productID(int)         : The id of the product
//  - afterTS(date)          : Filter excluding events before this date
//  - beforeTS(date)         : Filter excluding events after this date
//  - eventCodes(array)      : Filter, array of event codes
//  - anomalyClassIDs(array) : Filter, array of anomaly class ids
//  - cursor(Cursor)         : Cursor for pagination
//  - limit(int)             : The page size
function loadList(runID, productID, afterTS, beforeTS, eventCodes, anomalyClassIDs, cursor, limit) {
    D.Dispatcher.dispatch(_type(loadList.name), {
        runID: runID,
        productID: productID,
        afterTS: afterTS,
        beforeTS: beforeTS,
        eventCodes: eventCodes,
        anomalyClassIDs: anomalyClassIDs,
        cursor: cursor,
        limit: limit
    })
}

// Loads the aggregated events data for the chart.
// Args:
//  - runID(int)           : The id of the run
//  - afterTS(date)        : Filter excluding events before this date
//  - beforeTS(date)       : Filter excluding events after this date
//  - eventCodes(array)    : Filter, array of event codes
//  - numAggregations(int) : The number of aggregations
function loadChart(runID, afterTS, beforeTS, eventCodes, numAggregations) {
    D.Dispatcher.dispatch(_type(loadChart.name), {
        runID: runID,
        afterTS: afterTS,
        beforeTS: beforeTS,
        eventCodes: eventCodes,
        numAggregations: numAggregations
    })
}

// Loads the distribution of events.
// Args:
//  - runID(int)           : The id of the run
//  - afterTS(date)        : Filter excluding events before this date
//  - beforeTS(date)       : Filter excluding events after this date
//  - eventCodes(array)    : Filter, array of event codes
function loadDistribution(runID, afterTS, beforeTS, eventCodes) {
    D.Dispatcher.dispatch(_type(loadDistribution.name), {
        runID: runID,
        afterTS: afterTS,
        beforeTS: beforeTS,
        eventCodes, eventCodes
    })
}

// Loads the aggregated measure points data for the measurement chart.
// Args:
//  - runID(int)           : The id of the run
//  - afterTS(date)        : Filter excluding events before this date
//  - beforeTS(date)       : Filter excluding events after this date
//  - eventCodes(array)    : Filter, array of event codes
//  - numAggregations(int) : The number of aggregations
function loadMeasurementChart(runID, afterTS, beforeTS, eventCodes, numAggregations) {
    D.Dispatcher.dispatch(_type(loadMeasurementChart.name), {
        runID: runID,
        afterTS: afterTS,
        beforeTS: beforeTS,
        eventCodes: eventCodes,
        numAggregations: numAggregations
    })
}

//###############//
//### Private ###//
//###############//

// Returns the action type for the given function name of this script.
// Ret:
//  - string
function _type(funcName) {
    return "eventOverview" + funcName.capitalize()
}

