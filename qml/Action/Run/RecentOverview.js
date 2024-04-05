.pragma library

.import Dispatcher as D

// View the overview page of recent runs.
function view() {
    D.Dispatcher.dispatch(_type(view.name), {})
}

// View the events of the run with the given id.
// Args:
//  - runID(int)     : The id of the run.
//  - productID(int) : The id of the product.
function viewRunEvents(runID, productID) {
    D.Dispatcher.dispatch(_type(viewRunEvents.name), {
        runID: runID,
        productID: productID
    })
}

// Updates the filter stored in the state and requests the first page again.
// Args:
//  - productName(string) : The product name to filter by.
//  - runName(string)     : The run name to filter by.
//  - afterTS(date)       : Filter runs that appear before this timestamp.
//  - beforeTS(date)      : Filter runs that appear appear this timestamp.
function setFilter(productName, runName, afterTS, beforeTS) {
    D.Dispatcher.dispatch(_type(setFilter.name), {
        productName: productName,
        runName: runName,
        afterTS: afterTS,
        beforeTS: beforeTS
    })
}

// Sets the limit of the list.
// Args:
//  - limit(int) : The size of the page.
function setLimit(limit) {
    D.Dispatcher.dispatch(_type(setLimit.name), { limit: limit })
}

// Loads the first page of recent runs.
// The filter currently stored in the state are reused.
function loadFirstPage() {
    D.Dispatcher.dispatch(_type(loadFirstPage.name), {})
}

// Loads the next page of recent runs.
// The filter currently stored in the state are reused.
function loadNextPage() {
    D.Dispatcher.dispatch(_type(loadNextPage.name), {})
}

// Loads the previous page of recent runs.
// The filter currently stored in the state are reused.
function loadPrevPage() {
    D.Dispatcher.dispatch(_type(loadPrevPage.name), {})
}

//################//
//### Internal ###//
//################//

// Loads the page of recent runs.
// This is the only action used to trigger the Api request.
// Args:
//  - productName(string) : The product name to filter by.
//  - runName(string)     : The run name to filter by.
//  - afterTS(date)       : Filter runs that appear before this timestamp.
//  - beforeTS(date)      : Filter runs that appear appear this timestamp.
//  - cursor(Cursor)      : Cursor for pagination
//  - limit(int)          : The page size
function loadPage(productName, runName, afterTS, beforeTS, cursor, limit) {
    D.Dispatcher.dispatch(_type(loadPage.name), {
        productName: productName,
        runName: runName,
        afterTS: afterTS,
        beforeTS: beforeTS,
        cursor: cursor,
        limit: limit
    })
}

//###############//
//### Private ###//
//###############//

// Returns the action type for the given function name of this script.
// Ret:
//  - string
function _type(funcName) {
    return "runRecentOverview" + funcName.capitalize()
}
