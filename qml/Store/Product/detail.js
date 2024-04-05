.pragma library

.import Action as A
.import Lib as L

.import "../conv.js" as Conv

function view(state, data) {
    state.productDetail.id = data.id

    A.ANavigation.pushPage(L.Con.Page.ProductDetail)
}

//--------------------------------------------

function loadRecentRunsNumEventsOk(state, data) {
    state.productDetail.recentRunsNumEvents = data.numEvents ?? []
    state.productDetail.recentRunsNumEventsOldestTS = Date.fromGo(data.oldestTS)
    state.productDetail.recentRunsNumEventsNewestTS = Date.fromGo(data.newestTS)
}

//--------------------------------------------

function edit(state, data) {
    A.ANavigation.pushPage(L.Con.Page.ProductEdit)
}

//--------------------------------------------

function updateOk(state, data) {
    Conv.productFromGo(data)

    // Load the updated product.
    L.Obj.copyFrom(state.productDetail, data)

    // Load the updated fields also into the products.
    const idx = state.products.findIndex(p => p.id === data.id)
    if (idx >= 0) {
        L.Obj.copy(data, state.products[idx])
    }

    // Go back from the Edit product page.
    A.ANavigation.popPage()
}

//--------------------------------------------

function startReclassifyAllRunsOk(state, data) {
    state.productDetail.hasRunWithDirtyClassification = false

    A.AAppToast.showInfo(qsTr("Reclassification of all batches started.\nCheck the status page for the progress."))
}

//################//
//### Internal ###//
//################//

function loadOk(state, data) {
    L.Obj.copyFrom(state.productDetail, data)
    Conv.productDetailFromGo(state.productDetail)
}
