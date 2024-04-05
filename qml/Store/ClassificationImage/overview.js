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
    state.classificationImageOverview.productID = data.productID

    A.AAnomalyClass.load()
    A.AClassificationImageOverview.load(data.productID)
    A.ANavigation.pushPage(L.Con.Page.ClassificationImageOverview)
}

//################//
//### Internal ###//
//################//

function loadOk(state, data) {
    Conv.customTrainImagesFromGo(data.images)

    state.classificationImageOverview.images = data.images
}