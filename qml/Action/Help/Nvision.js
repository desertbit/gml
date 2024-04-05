.pragma library

.import Dispatcher as D

// Downloads the nVision binary from the nLine device for the requested Operating System.
// The binary is written to the filepath on the local system the user selects via the native file
// dialog provided through the App middleware.
// Args:
//  - os(string) : The target operating system
function download(os) {
    D.Dispatcher.dispatch(_type(download.name), { os: os })
}

// Saves the nVision binary on a storage device connected to nLine for the requested Operating System.
// Args:
//  - os(string)              : The target operating system
//  - storageDeviceID(string) : The id of the storage device to save the file to
function saveToStorage(os, storageDeviceID) {
    D.Dispatcher.dispatch(_type(saveToStorage.name), {
        os: os,
        storageDeviceID: storageDeviceID
    })
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
    return "helpNVision" + funcName.capitalize()
}
