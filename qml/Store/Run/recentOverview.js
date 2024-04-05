.pragma library

.import Action as A
.import Lib as L

.import "../conv.js" as Conv

function view() {
    A.ANavigation.pushPage(L.Con.Page.RunRecentOverview)
}

//--------------------------------------------

function viewRunEvents(state, data) {
    // Set the product & run id.
    state.eventOverview.productID = data.productID
    state.eventOverview.runID = data.runID

    A.ANavigation.pushPage(L.Con.Page.EventOverview)
}

//--------------------------------------------

function setFilter(state, data) {
    // Save the filter in the state.
    L.Obj.copyFrom(state.runRecentOverview.filter, data)

    // Request the first page again.
    A.ARunRecentOverview.loadFirstPage()
}

//--------------------------------------------

function setLimit(state, data) {
    state.runRecentOverview.limit = data.limit

    // Request the first page again.
    A.ARunRecentOverview.loadFirstPage()
}

//--------------------------------------------

function loadFirstPage(state, data) {
    // Reset the pagination cursor.
    state.runRecentOverview.cursor.after = ""
    state.runRecentOverview.cursor.before = ""

    // Issue the Api request.
    _loadPage(state)
}

//--------------------------------------------

function loadNextPage(state, data) {
    // Prepare the cursor to request the next page.
    state.runRecentOverview.cursor.before = ""

    // Issue the Api request.
    _loadPage(state)
}

//--------------------------------------------

function loadPrevPage(state, data) {
    // Prepare the cursor to request the previous page.
    state.runRecentOverview.cursor.after = ""

    // Issue the Api request.
    _loadPage(state)
}

//################//
//### Internal ###//
//################//

function loadPageOk(state, data) {
    Conv.runsFromGo(data.runs)

    state.runRecentOverview.page = data.runs
    state.runRecentOverview.totalCount = data.totalCount
    state.runRecentOverview.filteredCount = data.filteredCount
    L.Obj.copyFrom(state.runRecentOverview.cursor, data.cursor)
}

//###############//
//### Private ###//
//###############//

// Calls the loadPage action with the current state data.
function _loadPage(state) {
    A.ARunRecentOverview.loadPage(
        state.runRecentOverview.filter.productName,
        state.runRecentOverview.filter.runName,
        state.runRecentOverview.filter.afterTS,
        state.runRecentOverview.filter.beforeTS,
        state.runRecentOverview.cursor,
        state.runRecentOverview.limit
    )
}
