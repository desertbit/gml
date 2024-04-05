.pragma library

.import Dispatcher as D

.import Action.Internal as AInternal

// View the setup page from the status page.
function viewFromStatus() {
    D.Dispatcher.dispatch(_type(viewFromStatus.name), {})
}

// View the setup page from the settings page.
function viewFromSettings() {
    D.Dispatcher.dispatch(_type(viewFromSettings.name), {})
}

// Exports the current setup data.
// The file location is chosen via the App middleware.
function exportData() {
    D.Dispatcher.dispatch(_type(exportData.name), {})
}

// Exports the current setup data onto a storage device.
// Args:
//  - deviceID(string)                  : The id of the storage device.
//  - measuringHeadSerialNumber(string) : The serial number of the measuring head.
function exportDataToStorage(deviceID, measuringHeadSerialNumber) {
    D.Dispatcher.dispatch(_type(exportDataToStorage.name), { 
        deviceID: deviceID,
        measuringHeadSerialNumber: measuringHeadSerialNumber
    })
}

// Import data from a local file.
// The path is set by the App middleware.
function importData() {
    D.Dispatcher.dispatch(_type(importData.name), { path: "" })
}

// Import a setup configuration from a storage device.
// Args:
//  - fileName(string) : The name of a file on a storage device.
//  - deviceID(string) : The id of the storage device.
function importDataFromStorage(fileName, deviceID) {
    D.Dispatcher.dispatch(_type(importDataFromStorage.name), {
        fileName: fileName,
        deviceID: deviceID
    })
}

// Assign the position to the camera.
// Args:
//  - cameraID(int) : The id of the camera.
//  - position(int) : The new position.
function cameraAssignPosition(cameraID, position) {
    D.Dispatcher.dispatch(_type(cameraAssignPosition.name), {
        cameraID: cameraID,
        position: position
    })
}

// Assign the motor to the camera.
// Args:
//  - cameraID(int) : The id of the camera.
//  - motorID(int)  : The id of the motor.
function cameraAssignMotor(cameraID, motorID) {
    D.Dispatcher.dispatch(_type(cameraAssignMotor.name), {
        cameraID: cameraID,
        motorID: motorID
    })
}

// Cancels the assignment of motor to a camera.
// Args:
//  - callID(int) : The id of the call to cancel.
function cancelCameraAssignMotor(callID) {
    AInternal.emitCancel(callID)
}

// Perform a test drive of the motor currently assigned to the camera.
// Args:
//  - cameraID(int) : The id of the camera.
function cameraMotorTestDrive(cameraID) {
    D.Dispatcher.dispatch(_type(cameraMotorTestDrive.name), {
        cameraID: cameraID
    })
}

// Cancels the current test drive.
// Args:
//  - callID(int) : The id of the call to cancel.
function cancelCameraMotorTestDrive(callID) {
    AInternal.emitCancel(callID)
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
    return "setup" + funcName.capitalize()
}
