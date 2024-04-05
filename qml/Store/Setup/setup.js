.pragma library

.import Action as A
.import Lib as L

function viewFromStatus(state, data) {
    A.ANavigation.pushPage(L.Con.Page.Setup)
}

//--------------------------------------------

function viewFromSettings(state, data) {
    A.ANavigation.pushPage(L.Con.Page.Setup)
}

//--------------------------------------------

function exportData(state, data) {
    A.ANotification.addProgress(L.Con.Notification.SetupExportData, data.callID)
    A.AAppToast.showInfo(qsTr("Export started.")+"\n"+qsTr("Check notifications for progress."))
}

function exportDataUpdate(state, data) {
    A.ANotification.updateProgress(data.callID, data.progress)
}

function exportDataOk(state, data) {
    A.AAppToast.showSuccess(qsTr("Setup export finished."))
}

function exportDataDone(state, data) {
    A.ANotification.removeProgress(data.callID)
}

//--------------------------------------------

function exportDataToStorage(state, data) {
    A.ANotification.addProgress(L.Con.Notification.SetupExportData, data.callID)
    A.AAppToast.showInfo(qsTr("Export started.")+"\n"+qsTr("Check notifications for progress."))
}

function exportDataToStorageUpdate(state, data) {
    A.ANotification.updateProgress(data.callID, data.progress)
}

function exportDataToStorageOk(state, data) {
    A.AAppToast.showSuccess(qsTr("Setup export finished."))
}

function exportDataToStorageDone(state, data) {
    A.ANotification.removeProgress(data.callID)
}

//--------------------------------------------

function importData(state, data) {
    A.AApp.showBusyDialog(qsTr("Setup"), qsTr("nLine is performing the setup with the imported data."))
}

function importDataOk(state, data) {
    // Reload the cameras.
    A.ACamera.loadAll()
}

function importDataDone(state, data) {
    A.AApp.hideBusyDialog()
}

//--------------------------------------------

function importDataFromStorage(state, data) {
    A.AApp.showBusyDialog(qsTr("Setup"), qsTr("nLine is performing the setup with the imported data."))
}

function importDataFromStorageOk(state, data) {
    // Reload the cameras.
    A.ACamera.loadAll()
}

function importDataFromStorageDone(state, data) {
    A.AApp.hideBusyDialog()
}

//--------------------------------------------

function cameraAssignPositionOk(state, data) {
    // Assign the motor id to the camera.
    state.cameras.find(c => c.deviceID === data.cameraID).position = data.position
}

//--------------------------------------------

function cameraAssignMotor(state, data) {
    state.setup.motorAssignment.cameraID = data.cameraID
    state.setup.motorAssignment.callID = data.callID

    const title = qsTr("Assigning motor %1 to camera %2").arg(data.motorID).arg(data.cameraID)
    const msg = qsTr("The limit switch must be tested now. Please trigger the limit switch of the corresponding motor.")
    A.AApp.showBusyDialog(title, msg, data.callID)
}

function cameraAssignMotorOk(state, data) {
    // Assign the motor id to the camera.
    state.cameras.find(c => c.deviceID === data.cameraID).motorID = data.motorID
}

function cameraAssignMotorDone(state, data) {
    state.setup.motorAssignment.cameraID = ""
    state.setup.motorAssignment.callID = 0

    // Hide the busy dialog again.
    A.AApp.hideBusyDialog()
}

//--------------------------------------------

function cameraMotorTestDrive(state, data) {
    // Abort the current call first.
    if (state.setup.motorTestDrive.callID > 0) {
        A.ASetup.cancelCameraMotorTestDrive(state.setup.motorTestDrive.callID)
    }

    // Save the request data in the state.
    state.setup.motorTestDrive.callID = data.callID
    state.setup.motorTestDrive.cameraID = data.cameraID
    state.setup.motorTestDrive.active = true
}

function cameraMotorTestDriveDone(state, data) {
    state.setup.motorTestDrive.callID = 0
    state.setup.motorTestDrive.cameraID = ""
    state.setup.motorTestDrive.active = false
}

//################//
//### Internal ###//
//################//
