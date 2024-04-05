/**
 * nLine
 * 
 * Copyright (c) 2023 Wahtari GmbH
 * All rights reserved
 */

.pragma library

.import Dispatcher as D

// View the measurement calibration page of the given camera.
// Args:
//  - cameraID(string) : The id of the camera
function view(cameraID) {
    D.Dispatcher.dispatch(_type(view.name), { cameraID: cameraID })
}

// Sets the stream type of the given camera.
// Args:
//  - streamType(enum) : The type of stream.
function setStreamType(streamType) {
    D.Dispatcher.dispatch(_type(setStreamType.name), { streamType: streamType })
}

// Captures an image with the given measuring rod diameter and shows the preview
// to the user.
// Args:
//  - cameraID(string) : The id of the camera
//  - diameter(float)  : The diameter of the measuring rod in millimeters
//  - autofocus(bool)  : Whether to perform an autofocus beforehand.
function previewCapture(cameraID, diameter, autofocus) {
    D.Dispatcher.dispatch(_type(previewCapture.name), {
        cameraID: cameraID,
        diameter: diameter,
        autofocus: autofocus
    })
}

// Discards the image currently shown in the preview.
function discardCapture() {
    D.Dispatcher.dispatch(_type(discardCapture.name), {})
}

// Adds the image currently shown in the preview to the camera's measurement calibration.
// Args:
//  - cameraID(string) : The id of the camera
//  - diameter(float)  : The diameter of teh measuring rod in millimeters
//  - stepPos(int)     : The position of the step motor
//  - pixels(array)    : The pixels from the measurement
// Ret:
//  - dispatch promise
function addCapture(cameraID, diameter, stepPos, pixels) {
    return D.Dispatcher.dispatch(_type(addCapture.name), {
        cameraID: cameraID,
        diameter: diameter,
        stepPos: stepPos,
        pixels: pixels
    }, true)
}

// Calibrate the given camera regarding measurement.
// Args:
//  - cameraID(string) : The id of the camera
function calibrate(cameraID) {
    D.Dispatcher.dispatch(_type(calibrate.name), { cameraID: cameraID })
}

// Reset the calibration of the specified camera.
// Args:
//  - cameraID(string) : The id of the camera
function reset(cameraID) {
    D.Dispatcher.dispatch(_type(reset.name), { cameraID: cameraID })
}

//################//
//### Internal ###//
//################//

//###############//
//### Private ###//
//###############//

// Returns the action type for the given function name of this script.
// Ret:
//  - string
function _type(funcName) {
    return "setupCameraMeasCalib" + funcName.capitalize()
}
