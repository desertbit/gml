/**
 * nLine
 * 
 * Copyright (c) 2024 Wahtari GmbH
 * All rights reserved
 */

.pragma library

.import Dispatcher as D

// View the gallery of measurement calibration images of the given camera.
// Args:
//  - cameraID(string) : The id of the camera
function view(cameraID) {
    D.Dispatcher.dispatch(_type(view.name), { cameraID: cameraID })
}

// Remove the measurement calibration images with the given ids.
// Args:
//  - cameraID(string) : The id of the camera
//  - imageIDs(array)  : The ids of the images
// Ret:
//  - Dispatch promise
function remove(cameraID, imageIDs) {
    return D.Dispatcher.dispatch(_type(remove.name), { 
        cameraID: cameraID,
        imageIDs: imageIDs 
    }, true)
}

//################//
//### Internal ###//
//################//

// Load the images of the given camera.
// Args:
//  - cameraID(string) : The id of the camera
function loadImages(cameraID) {
    D.Dispatcher.dispatch(_type(loadImages.name), { cameraID: cameraID })
}

//###############//
//### Private ###//
//###############//

// Returns the action type for the given function name of this script.
// Ret:
//  - string
function _type(funcName) {
    return "setupCameraMeasCalibGallery" + funcName.capitalize()
}

