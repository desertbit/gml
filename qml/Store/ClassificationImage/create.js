/**
 * nLine
 * 
 * Copyright (c) 2023 Wahtari GmbH
 * All rights reserved
 */

.pragma library

.import Action as A
.import Lib as L

.import "../conv.js" as Conv
.import "../util.js" as Util

function view(state, data) {
    state.classificationImageCreate.event.id = data.eventID
    state.classificationImageCreate.event.productID = data.productID

    A.AClassificationImageCreate.loadEvent(data.eventID, data.productID)
    A.ANavigation.pushPage(L.Con.Page.ClassificationImageCreate)
}

//--------------------------------------------

function createOk(state, data) {
    // Modify the events in the whole store.
    Util.modifyEventsByIDs(state, [data.eventID], ev => ev.usedAsCustomTrainImage = true)

    // Leave the Create page.
    A.ANavigation.popPage()
}

//################//
//### Internal ###//
//################//

function loadEventOk(state, data) {
    Conv.eventFromGo(data)

    L.Obj.copyFrom(state.classificationImageCreate.event, data)
}