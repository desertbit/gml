/**
 * nLine
 * 
 * Copyright (c) 2023 Wahtari GmbH
 * All rights reserved
 */

.pragma library

.import Dispatcher as D
.import Lib as L

// View the camera detail page and start the stream with the given stream type.
// Args:
//  - deviceID(string) : The id of the camera
//  - streamType(enum) : The type of the camera stream
function view(deviceID, streamType=L.Con.StreamType.Raw) {
    D.Dispatcher.dispatch(_type(view.name), { 
        deviceID: deviceID,
        streamType: streamType 
    })
}

// Set the stream type on the camera detail page.
// Args:
//  - streamType(enum) : The type of the camera stream
function setStreamType(streamType) {
    D.Dispatcher.dispatch(_type(setStreamType.name), { streamType: streamType })
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
    return "cameraDetail" + funcName.capitalize()
}
