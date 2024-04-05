.pragma library

.import Action as A
.import Lib as L

.import "../conv.js" as Conv

function viewFromRunDetail(state, data) {
    state.eventDetail.id = data.id
    state.eventDetail.runID = data.runID
    state.eventDetail.productID = data.productID
    state.eventDetail.filter.afterTS = L.LDate.Invalid
    state.eventDetail.filter.beforeTS = L.LDate.Invalid
    state.eventDetail.filter.eventCodes = []
    state.eventDetail.filter.anomalyClassIDs = null
    state.eventDetail.skippedOverview = true

    _load(state)
    A.AAnomalyClass.load()
    A.ANavigation.pushPage(L.Con.Page.EventDetail)
}

//--------------------------------------------

function viewFromStatus(state, data) {
    state.eventDetail.id = data.id
    state.eventDetail.runID = data.runID
    state.eventDetail.productID = data.productID
    state.eventDetail.filter.afterTS = L.LDate.Invalid
    state.eventDetail.filter.beforeTS = L.LDate.Invalid
    state.eventDetail.filter.eventCodes = []
    state.eventDetail.filter.anomalyClassIDs = null
    state.eventDetail.skippedOverview = true

    _load(state)
    A.AAnomalyClass.load()
    A.ANavigation.pushPage(L.Con.Page.EventDetail)
}

//--------------------------------------------

function viewFromOverview(state, data) {
    state.eventDetail.id = data.id
    state.eventDetail.runID = data.runID
    state.eventDetail.productID = data.productID
    state.eventDetail.filter.afterTS = data.afterTS
    state.eventDetail.filter.beforeTS = data.beforeTS
    state.eventDetail.filter.eventCodes = data.eventCodes
    state.eventDetail.filter.anomalyClassIDs = data.anomalyClassIDs

    _load(state)
    A.AAnomalyClass.load()
    A.ANavigation.pushPage(L.Con.Page.EventDetail)
}

//--------------------------------------------

function viewNext(state, data) {
    state.eventDetail.id = state.eventDetail.nextID

    _load(state)
}

//--------------------------------------------

function viewPrev(state, data) {
    state.eventDetail.id = state.eventDetail.prevID

    _load(state)
}

//################//
//### Internal ###//
//################//

function loadOk(state, data) {
    L.Obj.copyFrom(state.eventDetail, data)

    Conv.eventFromGo(state.eventDetail, state.eventDetail.productID)
}

//###############//
//### Private ###//
//###############//

function _load(state) {
    A.AEventDetail.load(
        state.eventDetail.id,
        state.eventDetail.runID,
        state.eventDetail.productID,
        state.eventDetail.filter.afterTS,
        state.eventDetail.filter.beforeTS,
        state.eventDetail.filter.eventCodes,
        state.eventDetail.filter.anomalyClassIDs
    )
}
