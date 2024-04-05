.pragma library

.import Action as A
.import Lib as L

.import "../conv.js" as Conv

function viewFromProductDetail(state, data) {
    // Set the product id.
    state.runOverview.productID = state.productDetail.id

    A.ANavigation.pushPage(L.Con.Page.RunOverview)
}

//--------------------------------------------

function viewFromProductOverview(state, data) {
    // Set some data, so the run overview correctly shows the fact we skipped the product detail.
    state.runOverview.skippedProductDetail = true
    state.runOverview.skippedProductName = state.products.find(p => p.id === data.id).name

    // Set the product id.
    state.runOverview.productID = data.id

    A.ANavigation.pushPage(L.Con.Page.RunOverview)
}

//--------------------------------------------

function setFilter(state, data) {
    // Copy the current filter settings into our state.
    L.Obj.copyFrom(state.runOverview.filter, data)

    // Request the first page again.
    A.ARunOverview.loadFirstPage()
}

//--------------------------------------------

function setLimit(state, data) {
    state.runOverview.limit = data.limit

    // Request the first page again.
    A.ARunOverview.loadFirstPage()
}

//--------------------------------------------

function loadFirstPage(state, data) {
    // Reset the pagination cursor.
    state.runOverview.cursor.after = ""
    state.runOverview.cursor.before = ""

    // Issue the Api request.
    _loadPage(state)
}

//--------------------------------------------

function loadNextPage(state, data) {
    // Prepare the cursor to request the next page.
    state.runOverview.cursor.before = ""

    // Issue the Api request.
    _loadPage(state)
}

//--------------------------------------------

function loadPrevPage(state, data) {
    // Prepare the cursor to request the previous page.
    state.runOverview.cursor.after = ""

    // Issue the Api request.
    _loadPage(state)
}

//################//
//### Internal ###//
//################//

function loadPageOk(state, data) {
    Conv.runsFromGo(data.runs)

    state.runOverview.page = data.runs
    state.runOverview.totalCount = data.totalCount
    state.runOverview.filteredCount = data.filteredCount
    L.Obj.copyFrom(state.runOverview.cursor, data.cursor)
}

//###############//
//### Private ###//
//###############//

// Calls loadPage with the current state data.
function _loadPage(state) {
    A.ARunOverview.loadPage(
        state.runOverview.productID,
        state.runOverview.filter.name,
        state.runOverview.filter.afterTS,
        state.runOverview.filter.beforeTS,
        state.runOverview.cursor,
        state.runOverview.limit
    )
}
