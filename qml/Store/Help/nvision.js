.pragma library

.import Action as A
.import Lib as L

function download(state, data) {
    A.ANotification.addProgress(L.Con.Notification.DownloadNVision, data.callID)
    A.AAppToast.showInfo(qsTr("Download started.")+"\n"+qsTr("Check notifications for progress."))
}

function downloadUpdate(state, data) {
    A.ANotification.updateProgress(data.callID, data.progress)
}

function downloadOk(state, data) {
    A.AAppToast.showSuccess(qsTr("Download finished."))
}

function downloadDone(state, data) {
    A.ANotification.removeProgress(data.callID)
}

//--------------------------------------------

function saveToStorage(state, data) {
    A.ANotification.addProgress(L.Con.Notification.SaveNVisionToStorage, data.callID)
    A.AAppToast.showInfo(qsTr("Download started.")+"\n"+qsTr("Check notifications for progress."))
}

function saveToStorageUpdate(state, data) {
    A.ANotification.updateProgress(data.callID, data.progress)
}

function saveToStorageOk(state, data) {
    A.AAppToast.showSuccess(qsTr("Download finished.") + "\n" + qsTr("You can now safely remove the storage device."))
}

function saveToStorageDone(state, data) {
    A.ANotification.removeProgress(data.callID)
}

//################//
//### Internal ###//
//################//
