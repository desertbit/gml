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
    state.cameraDetail.deviceID = data.deviceID
    state.cameraDetail.streamType = data.streamType

    A.ANavigation.pushPage(L.Con.Page.CameraDetail)
}

//--------------------------------------------

function setStreamType(state, data) {
    state.cameraDetail.streamType = data.streamType

    A.ACamera.startStream(state.cameraDetail.deviceID, data.streamType)

    // Ensure the camera is no longer paused.
    const cam = state.cameras.find(c => c.deviceID === state.cameraDetail.deviceID)
    if (cam) {
        cam.paused = false
    }
}

//################//
//### Internal ###//
//################//