.pragma library

.import Lib as L

function viewNotifications(state, data) {
    state.notifications.unread = 0
}

//--------------------------------------------

function loadStorageDevicesOk(state, data) {
    state.nline.storageDevices = data.devices
}

//--------------------------------------------

function loadStorageDevicesFilesOk(state, data) {
    state.nline.storageDevicesFiles = data.files
}

//################//
//### Internal ###//
//################//
