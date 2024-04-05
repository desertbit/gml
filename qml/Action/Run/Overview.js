.pragma library

.import Dispatcher as D

// Navigate to the run overview from the product detail page.
// Args:
//  - id(int) : The id of the product.
function viewFromProductDetail(id) {
    D.Dispatcher.dispatch(_type(viewFromProductDetail.name), { id: id })
}

// Navigate to the run overview from the product overview page.
// This shows the runs of a product without visiting its detail first.
// Args:
//  - id(int) : The id of the product.
function viewFromProductOverview(id) {
    D.Dispatcher.dispatch(_type(viewFromProductOverview.name), { id: id })
}

// Updates the filter stored in the state and requests the first page again.
// Args:
//  - name(string)   : The run name to filter by.
//  - afterTS(date)  : Filter runs that appear before this timestamp.
//  - beforeTS(date) : Filter runs that appear appear this timestamp.
function setFilter(name, afterTS, beforeTS) {
    D.Dispatcher.dispatch(_type(setFilter.name), {
        name: name,
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

// Loads the first page of runs.
// The filter currently stored in the state are reused.
function loadFirstPage() {
    D.Dispatcher.dispatch(_type(loadFirstPage.name), {})
}

// Loads the next page of runs.
// The filter currently stored in the state are reused.
function loadNextPage() {
    D.Dispatcher.dispatch(_type(loadNextPage.name), {})
}

// Loads the previous page of runs.
// The filter currently stored in the state are reused.
function loadPrevPage() {
    D.Dispatcher.dispatch(_type(loadPrevPage.name), {})
}

//################//
//### Internal ###//
//################//

// Loads the page of the runs.
// This is the only action used to trigger the Api request.
// Args:
//  - productID(int) : The id of the product
//  - name(string)   : Filter, name of the run
//  - afterTS(date)  : Filter runs that appear before this timestamp.
//  - beforeTS(date) : Filter runs that appear appear this timestamp.
//  - cursor(Cursor) : Cursor for pagination
//  - limit(int)     : The page size
function loadPage(productID, name, afterTS, beforeTS, cursor, limit) {
    D.Dispatcher.dispatch(_type(loadPage.name), {
        productID: productID,
        name: name,
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
    return "runOverview" + funcName.capitalize()
}
