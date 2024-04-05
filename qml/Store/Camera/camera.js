/**
 * nLine
 * 
 * Copyright (c) 2023 Wahtari GmbH
 * All rights reserved
 */

.pragma library

.import Action as A
.import Lib as L

//--------------------------------------------

function pauseStreamOk(state, data) {
    _camera(state, data.deviceID).paused = true
}

//--------------------------------------------

function resumeStreamOk(state, data) {
    _camera(state, data.deviceID).paused = false
}

//--------------------------------------------

function setFocusStepPos(state, data) {
    _camera(state, data.deviceID).moving = true
}

function setFocusStepPosDone(state, data) {
    const cam = _camera(state, data.deviceID)
    cam.focus.stepPos = data.stepPos
    cam.moving = false
}

//--------------------------------------------

function calibrateFocus(state, data) {
    const cam = _camera(state, data.deviceID)

    // Abort the current stream first.
    if (cam.calibratingFocus) {
        A.AInt.emitCancel(cam.calibrateFocusCallID)
    }

    cam.calibratingFocus = true
    cam.calibrateFocusCallID = data.callID
}

function calibrateFocusOk(state, data) {
    L.Obj.copyFrom(_camera(state, data.deviceID).focus, data.focus)
}

function calibrateFocusDone(state, data) {
    let cam = null
    if (data.api.canceled || data.api.failed) {
        cam = state.cameras.find(c => c.calibrateFocusCallID === data.callID)
    } else {
        cam = _camera(state, data.deviceID)
    }
    cam.calibratingFocus = false
}

//--------------------------------------------

function autofocus(state, data) {
    const cam = _camera(state, data.deviceID)

    // Abort the current stream first.
    if (cam.autofocusing) {
        A.AInt.emitCancel(cam.autofocusCallID)
    }

    cam.autofocusing = true
    cam.autofocusCallID = data.callID
}

function autofocusOk(state, data) {
    L.Obj.copyFrom(_camera(state, data.deviceID).focus, data.focus)
}

function autofocusDone(state, data) {
    let cam = null
    if (data.api.canceled || data.api.failed) {
        cam = state.cameras.find(c => c.autofocusCallID === data.callID)
    } else {
        cam = _camera(state, data.deviceID)
    }
    cam.autofocusing = false
}

//--------------------------------------------

function autofocusAll(state, data) {
    // Set all cameras into autofocus mode.
    state.cameras.forEach(c => {
        // Abort the current stream first.
        if (c.autofocusing) {
            A.AInt.emitCancel(c.autofocusCallID)
        }

        c.autofocusing = true
        c.autofocusCallID = data.callID
    })
}

function autofocusAllOk(state, data) {
    // Copy the focus positions into the cameras.
    state.cameras.forEach(c => L.Obj.copyFrom(c.focus, data.foci[c.deviceID]))
}

function autofocusAllDone(state, data) {
    // Reset the autofocus mode on all cameras.
    state.cameras.forEach(c => c.autofocusing = false)
}

//################//
//### Internal ###//
//################//

function loadAllOk(state, data) {
    if (state.cameras.length != data.length) {
        // Overwrite the cameras completely.
        L.Obj.copy(data, state.cameras)
        return
    }

    // Load the data of each camera.
    // Does only overwrite properties that data contains.
    state.cameras.forEach(c => L.Obj.copyFrom(c, data.find(dc => dc.deviceID === c.deviceID)))
}

function loadFocusOk(state, data) {
    L.Obj.copyFrom(_camera(state, data.deviceID).focus, data.focus)
}

//###############//
//### Private ###//
//###############//

function _camera(state, deviceID) {
    return state.cameras.find(c => c.deviceID === deviceID)
}