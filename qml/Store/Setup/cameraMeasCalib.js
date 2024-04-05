/**
 * nLine
 * 
 * Copyright (c) 2023 Wahtari GmbH
 * All rights reserved
 */

.pragma library

.import Action as A
.import Lib as L

.import "../initState.js" as Init

function view(state, data) {
    state.setupCameraMeasCalib.cameraID = data.cameraID

    A.ACamera.loadFocus(data.cameraID)
    A.ANavigation.pushPage(L.Con.Page.SetupCameraMeasCalib)
}

//--------------------------------------------

function setStreamType(state, data) {
    state.setupCameraMeasCalib.streamType = data.streamType

    // Restart the camera streams.
    A.ACamera.startStream(state.setupCameraMeasCalib.cameraID, data.streamType)
}

//--------------------------------------------

function previewCapture(state, data) {
    // Save the diameter from the request.
    state.setupCameraMeasCalib.preview.diameter = data.diameter

    // The camera is now doing an autofocus.
    const cam = state.cameras.find(c => c.deviceID === state.setupCameraMeasCalib.cameraID)
    cam.autofocusing = true
}

function previewCaptureOk(state, data) {
    state.setupCameraMeasCalib.preview.active = true
    state.setupCameraMeasCalib.preview.stepPos = data.stepPos
    state.setupCameraMeasCalib.preview.pixels = data.pixels

    // Update the focus position of the camera as well.
    const cam = state.cameras.find(c => c.deviceID === state.setupCameraMeasCalib.cameraID)
    cam.focus.stepPos = data.stepPos
}

function previewCaptureFailed(state, data) {
    state.setupCameraMeasCalib.preview.active = false
}

function previewCaptureDone(state, data) {
    const cam = state.cameras.find(c => c.deviceID === state.setupCameraMeasCalib.cameraID)
    cam.autofocusing = false
}

//--------------------------------------------

function discardCapture(state, data) {
    _resetPreview(state)
}

//--------------------------------------------

function addCaptureOk(state, data) {
    const cam = state.cameras.find(c => c.deviceID === state.setupCameraMeasCalib.cameraID)
    cam.measCalibImagesCount++
}

function addCaptureDone(state, data) {
    _resetPreview(state)
}

//--------------------------------------------

function calibrate(state, data) {
    A.AApp.showBusyDialog(qsTr("Calibrating measurement"), qsTr("Please standby") + "...")
}

function calibrateOk(state, data) {
    // Camera is now calibrated.
    state.cameras.find(c => c.deviceID === state.setupCameraMeasCalib.cameraID).isMeasurementCalibrated = true

    // Start the measurement stream for the current camera.
    if (state.setupCameraMeasCalib.streamType !== L.Con.StreamType.Measurement) {
        A.ASetupCameraMeasCalib.setStreamType(L.Con.StreamType.Measurement)
    }
}

function calibrateDone(state, data) {
    A.AApp.hideBusyDialog()
}

//--------------------------------------------

function reset(state, data) {
    // Start the raw stream for the current camera again.
    if (state.setupCameraMeasCalib.streamType !== L.Con.StreamType.Raw) {
        A.ASetupCameraMeasCalib.setStreamType(L.Con.StreamType.Raw)
    }
}

function resetOk(state, data) {
    // Camera is no longer calibrated.
    state.cameras.find(c => c.deviceID === state.setupCameraMeasCalib.cameraID).isMeasurementCalibrated = false
}

//################//
//### Internal ###//
//################//

//###############//
//### Private ###//
//###############//

function _resetPreview(state) {
    state.setupCameraMeasCalib.preview.active = false
    state.setupCameraMeasCalib.preview.diameter = 0
    state.setupCameraMeasCalib.preview.stepPos = 0
    state.setupCameraMeasCalib.preview.pixels = []
}