/**
 * nLine
 * 
 * Copyright (c) 2024 Wahtari GmbH
 * All rights reserved
 */

.pragma library

.import Action as A
.import Lib as L

function view(state, data) {
    state.setupCameraMeasCalibGallery.cameraID = data.cameraID

    A.ASetupCameraMeasCalibGallery.loadImages(data.cameraID)
    A.ANavigation.pushPage(L.Con.Page.SetupCameraMeasCalibGallery)
}

//--------------------------------------------

function removeOk(state, data) {
    state.setupCameraMeasCalibGallery.images = state.setupCameraMeasCalibGallery.images.filter(img => !data.imageIDs.includes(img.id))

    // Decrement the count of the camera.
    const cam = state.cameras.find(c => c.deviceID === state.setupCameraMeasCalibGallery.cameraID)
    cam.measCalibImagesCount -= data.imageIDs.length
}

//################//
//### Internal ###//
//################//

function loadImagesOk(state, data) {
    state.setupCameraMeasCalibGallery.images = data.images
}