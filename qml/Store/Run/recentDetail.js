.pragma library

.import Action as A
.import Lib as L

.import "../conv.js" as Conv

function view(state, data) {
    state.runRecent.id = data.id

    A.ANavigation.pushPage(L.Con.Page.RunRecentDetail)
}

//################//
//### Internal ###//
//################//

function loadOk(state, data) {
    L.Obj.copyFrom(state.runRecent, data)

    Conv.runFromGo(state.runRecent)
    Conv.runPausesFromGo(state.runRecent.pauses)
    Conv.eventsFromGo(state.runRecent.latestEvents, state.runRecent.productID)
    Conv.aggrEventsFromGo(state.runRecent.aggrEvents)
    Conv.aggrMeasurePointsFromGo(state.runRecent.aggrMeasurePoints)
}
