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
    state.cameraFocus.activeCameraID = state.cameras[0].deviceID

    A.ACamera.loadFocus(state.cameraFocus.activeCameraID)
    A.ANavigation.pushPage(L.Con.Page.CameraFocus)
}

//--------------------------------------------

function viewFromProductDetail(state, data) {
    state.cameraFocus.activeCameraID = state.cameras[0].deviceID
    state.cameraFocus.productID = data.productID
    state.cameraFocus.editingProduct = true

    A.ACamera.loadFocus(state.cameraFocus.activeCameraID)
    A.ANavigation.pushPage(L.Con.Page.CameraFocus)
}

//--------------------------------------------

function selectCamera(state, data) {
    state.cameraFocus.activeCameraID = data.deviceID

    A.ACamera.loadFocus(state.cameraFocus.activeCameraID)
}

//--------------------------------------------

function saveToProductDone(state, data) {
    if (data.api.ok) {
        // Leave the camera focus page.
        A.ANavigation.popPage()
    }
}

//################//
//### Internal ###//
//################//
