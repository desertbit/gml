.pragma library

.import Action as A
.import Lib as L

.import "../conv.js" as Conv

function view(state, data) {
    state.runExport.skippedRunDetail = true

    A.ARunExport.loadRuns(data.ids)
    A.ANavigation.pushPage(L.Con.Page.RunExport)
}

//--------------------------------------------

function viewFromRunDetail(state, data) {
    A.ARunExport.loadRuns(data.ids)
    A.ANavigation.pushPage(L.Con.Page.RunExport)
}

//--------------------------------------------

function download(state, data) {
    // Add a notification item for the download.
    A.ANotification.addProgress(L.Con.Notification.DownloadRunExport, data.callID)

    // Leave the export page.
    A.ANavigation.popPage()
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
    // Add a notification item for the download.
    A.ANotification.addProgress(L.Con.Notification.SaveRunExportToStorage, data.callID)

    // Leave the export page.
    A.ANavigation.popPage()
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

function loadRunsOk(state, data) {
    Conv.runsFromGo(data.runs)

    state.runExport.runs = data.runs
}
