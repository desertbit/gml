.pragma library

.import Action as A
.import Lib as L

.import "../conv.js" as Conv

function removeOk(state, data) {
    const isRunRecentPage = [L.Con.Page.RunRecentDetail, L.Con.Page.RunRecentOverview].includes(state.app.pages[0])
    const removedOnDetailPage = [L.Con.Page.RunRecentDetail, L.Con.Page.RunDetail].includes(state.app.pages[0])

    // Reload current page.
    if (isRunRecentPage) {
        A.ARunRecentOverview.loadFirstPage()
    } else {
        A.ARunOverview.loadFirstPage()
    }

    // Reload product detail, if it is there.
    if (state.app.pages.includes(L.Con.Page.ProductDetail)) {
        A.AProductDetail.load(state.productDetail.id)
    }

    // Go back from the details page.
    if (removedOnDetailPage) {
        A.ANavigation.popPage()
    }
}

//--------------------------------------------

function startReclassifyOk(state, data) {
    // Reset the dirty flag where needed.
    if (state.runRecent.id === data.id) {
        state.runRecent.classificationDirty = false
    }
    if (state.runDetail.id === data.id) {
        state.runDetail.classificationDirty = false
    }

    A.AAppToast.showInfo(qsTr("Reclassification of a batch started.\nCheck the status page for the progress."))
}

//################//
//### Internal ###//
//################//
