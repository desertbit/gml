.pragma library

.import Dispatcher as D

// Views the notifications.
function viewNotifications() {
    D.Dispatcher.dispatch(_type(viewNotifications.name), {})
}

// Loads all storage devices available on the nLine device.
function loadStorageDevices() {
    D.Dispatcher.dispatch(_type(loadStorageDevices.name), {})
}

// Loads all files on every storage device available on the nLine device.
function loadStorageDevicesFiles() {
    D.Dispatcher.dispatch(_type(loadStorageDevicesFiles.name), {})
}

// Downloads the latest nVision binary from the nLine device, installs
// it locally and restarts nVision.
// The actual installation steps depend on the OS.
function downloadNVisionAndRestart() {
    D.Dispatcher.dispatch(_type(downloadNVisionAndRestart.name), {})
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
    return "global" + funcName.capitalize()
}
