.pragma library

.import Action as A
.import Lib as L

.import "../conv.js" as Conv

function viewFromRunOverview(state, data) {
    state.runDetail.id = data.id

    A.ANavigation.pushPage(L.Con.Page.RunDetail)
}

//--------------------------------------------

function viewFromProductDetail(state, data) {
    state.runDetail.id = data.id
    state.runDetail.skippedRunOverview = true

    A.ANavigation.pushPage(L.Con.Page.RunDetail)
}

//################//
//### Internal ###//
//################//

function loadOk(state, data) {
    L.Obj.copyFrom(state.runDetail, data)

    Conv.runFromGo(state.runDetail)
    Conv.runPausesFromGo(state.runDetail.pauses)
    Conv.eventsFromGo(state.runDetail.latestEvents, state.runDetail.productID)
    Conv.aggrEventsFromGo(state.runDetail.aggrEvents)
    Conv.aggrMeasurePointsFromGo(state.runDetail.aggrMeasurePoints)
}
