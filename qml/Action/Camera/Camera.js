.pragma library

.import Dispatcher as D

.import Action.Internal as AInternal

// Sets the focus step position of the given camera.
// Args:
//  - deviceID(string) : The device id of the camera
//  - stepPos(int)     : The position the camera's focus motor should move to
function setFocusStepPos(deviceID, stepPos) {
    D.Dispatcher.dispatch(_type(setFocusStepPos.name), {
        deviceID: deviceID,
        stepPos: stepPos
    })
}

// Calibrates the focus on the given camera.
// Args:
//  - deviceID(string)  : The device id of the camera
function calibrateFocus(deviceID) {
    D.Dispatcher.dispatch(_type(calibrateFocus.name), { deviceID: deviceID })
}

// Cancels the current calibrate focus operation.
// Args:
//  - callID(int) : The callID of the request
function cancelCalibrateFocus(callID) {
    AInternal.emitCancel(callID)
}

// Triggers the autofocus on the given camera.
// Args:
//  - deviceID(string) : The device id of the camera
function autofocus(deviceID) {
    D.Dispatcher.dispatch(_type(autofocus.name), { deviceID: deviceID })
}

// Cancels the current autofocus operation.
// Args:
//  - callID(int) : The callID of the request
function cancelAutofocus(callID) {
    AInternal.emitCancel(callID)
}

// Pauses the stream of the given camera.
// Args:
//  - deviceID(string) : The id of the camera.
function pauseStream(deviceID) {
    D.Dispatcher.dispatch(_type(pauseStream.name), { deviceID: deviceID })
}

// Resumes the stream of the given camera.
// Args:
//  - deviceID(string) : The id of the camera.
function resumeStream(deviceID) {
    D.Dispatcher.dispatch(_type(resumeStream.name), { deviceID: deviceID })
}

// Performs an autofocus operation on all cameras.
function autofocusAll() {
    D.Dispatcher.dispatch(_type(autofocusAll.name), {})
}

//################//
//### Internal ###//
//################//

// Loads all cameras.
// Ret:
//  - Dispatch promise
function loadAll() {
    return D.Dispatcher.dispatch(_type(loadAll.name), {}, true)
}

// Loads the focus data of the given camera.
// Args:
//  - deviceID(string) : The id of the camera.
function loadFocus(deviceID) {
    D.Dispatcher.dispatch(_type(loadFocus.name), { deviceID: deviceID })
}

// Starts streams of all cameras with the given stream type.
// Args:
//  - streamType(enum) : The type of stream.
function startStreams(streamType) {
    D.Dispatcher.dispatch(_type(startStreams.name), { streamType: streamType })
}

// Starts a stream of the given camera with the given stream type.
// Args:
//  - deviceID(string) : The id of the camera.
//  - streamType(enum) : The type of stream.
function startStream(deviceID, streamType) {
    D.Dispatcher.dispatch(_type(startStream.name), { 
        deviceID: deviceID,
        streamType: streamType 
    })
}

// Stops streams of all cameras.
function stopStreams() {
    D.Dispatcher.dispatch(_type(stopStreams.name), {})
}

// Stops the stream of the given camera.
// Args:
//  - deviceID(string) : The id of the camera.
function stopStream(deviceID) {
    D.Dispatcher.dispatch(_type(stopStream.name), { deviceID: deviceID })
}

//###############//
//### Private ###//
//###############//

// Returns the action type for the given function name of this script.
// Ret:
//  - string
function _type(funcName) {
    return "camera" + funcName.capitalize()
}
