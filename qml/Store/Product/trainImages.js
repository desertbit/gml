/**
 * nLine
 * 
 * Copyright (c) 2023 Wahtari GmbH
 * All rights reserved
 */

.pragma library

.import Action as A
.import Lib as L

function view(state, data) {
    state.productTrainImages.productID = data.productID

    A.AProductTrainImages.load(data.productID)
    A.ANavigation.pushPage(L.Con.Page.ProductTrainImages)
}

//--------------------------------------------

function removeOk(state, data) {
    state.productTrainImages.images = state.productTrainImages.images.filter(id => !data.imageIDs.includes(id))
}

//################//
//### Internal ###//
//################//

function loadOk(state, data) {
    state.productTrainImages.images = data.imageIDs
}
