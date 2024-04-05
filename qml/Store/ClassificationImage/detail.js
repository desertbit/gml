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

function view(state, data) {
    state.classificationImageDetail.id = data.id

    _load(state)
    A.ANavigation.pushPage(L.Con.Page.ClassificationImageDetail)
}

//--------------------------------------------

function viewFromEvent(state, data) {
    state.classificationImageDetail.fromEvent = true

    A.AClassificationImageDetail.loadFromEvent(data.eventID)
    A.ANavigation.pushPage(L.Con.Page.ClassificationImageDetail)
}

//--------------------------------------------

function updateClassesOk(state, data) {

    // Replace the detail data.
    state.classificationImageDetail.anomalyBoxes = data.anomalyBoxes
    // Replace the overview data.
    const img = state.classificationImageOverview.images.find(img => img.id === data.id)
    if (img) {
        img.anomalyBoxes = data.anomalyBoxes
    }
}

//--------------------------------------------

function viewNext(state, data) {
    state.classificationImageDetail.id = state.classificationImageDetail.nextID

    // Load new detail data.
    _load(state)
}

//--------------------------------------------

function viewPrev(state, data) {
    state.classificationImageDetail.id = state.classificationImageDetail.prevID

    // Load new detail data.
    _load(state)
}

//################//
//### Internal ###//
//################//

function loadOk(state, data) {
    L.Obj.copyFrom(state.classificationImageDetail, data)
}

//--------------------------------------------

function loadFromEventOk(state, data) {
    L.Obj.copyFrom(state.classificationImageDetail, data)
}

//###############//
//### Private ###//
//###############//

function _load(state) {
    A.AClassificationImageDetail.load(state.classificationImageDetail.id)
}
