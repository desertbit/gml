.pragma library

.import Dispatcher as D

// Download the content of the given resource.
// The data is written to the filepath on the local system the user selects via the native file
// dialog provided through the App middleware.
// Args:
//  - id(int)        : The id of the resource
//  - locale(string) : The locale of the resource
function download(id, locale) {
    D.Dispatcher.dispatch(_type(download.name), {
        id: id,
        locale: locale
    })
}

// Saves the resource data on a storage device connected to nLine.
// The storage device is selected by the user via device dialog provided through the App middleware.
// Args:
//  - id(int)                 : The id of the resource
//  - locale(string)          : The locale of the resource
//  - storageDeviceID(string) : The id of the storage device to save the file to
function saveToStorage(id, locale, storageDeviceID) {
    D.Dispatcher.dispatch(_type(saveToStorage.name), {
        id: id,
        locale: locale,
        storageDeviceID, storageDeviceID
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
    return "helpResource" + funcName.capitalize()
}
