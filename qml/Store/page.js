// This file contains functions for the lifecycle of pages.
// Each page receives 4 different signals in its lifetime.
//  - <page>Created : Called once, when the page is created
//  - <page>Resumed : Called everytime, the page becomes the active item in the stack
//  - <page>Pasued  : Called everytime, the page becomes inactive in the stack
//  - <page>Destroyed : Called once, when the page is destroyed
//
// An example life cycle of a page could look like this:
//  - Created -> Resumed -> Paused -> Resumed -> Paused -> Destroyed

.pragma library

.import Action as A
.import Lib as L

//####################//
//### AnomalyClass ###//
//####################//

function anomalyClassOverviewDestroyed(state) {
    state.anomalyClassOverview.selectedColors = {}
}

//##############//
//### Camera ###//
//##############//

function cameraDetailCreated(state) {
    A.ACamera.startStream(state.cameraDetail.deviceID, state.cameraDetail.streamType)
}

function cameraDetailDestroyed(state) {
    A.ACamera.stopStream(state.cameraDetail.deviceID)
}

//--------------------------------------------

function cameraFocusResumed(state) {
    A.ACamera.startStreams(L.Con.StreamType.Raw)
}

function cameraFocusDestroyed(state) {
    A.ACamera.stopStreams()
    state.cameraFocus.editingProduct = false
}

//###########################//
//### ClassificationImage ###//
//###########################//

function classificationImageDetailDestroyed(state) {
    state.classificationImageDetail.fromEvent = false
}

//--------------------------------------------

function classificationImageOverviewDestroyed(state) {
    state.classificationImageOverview.images = []
}

//#################//
//### Dashboard ###//
//#################//

function dashboardDestroyed(state) {
    A.ADashboard.unsubscribeStats(state.nline.stats.callID)
}

//#############//
//### Event ###//
//#############//

function eventOverviewDestroyed(state) {
    state.eventOverview.skippedRunOverview = false
    state.eventOverview.skippedRunDetail = false
    state.eventOverview.skippedRunName = ""
    state.eventOverview.chart.points = []
}

//############//
//### Help ###//
//############//

function helpResumed(state) {
    // Request the storage devices, if configured.
    if (state.app.opts.withStorageDevices) {
        A.AGlobal.loadStorageDevices()
    }
}

//#############//
//### Login ###//
//#############//

function loginConnectResumed(state) {
    A.ALoginConnect.start(state.loginConnect.addr, "", "")
}

function loginConnectPaused(state) {
    if (state.loginConnect.callID > 0) {
        A.ALoginConnect.stop(state.loginConnect.callID)
    }
}

//--------------------------------------------

function loginDiscoveryResumed(state) {
    A.ALoginDiscovery.search()
}

function loginDiscoveryPaused(state) {
    A.ALoginDiscovery.stopSearch(state.loginDiscovery.callID)
}

//##################//
//### PDFPreview ###//
//##################//

function pdfPreviewDestroyed(state) {
    if (state.pdfPreview.callID > 0) {
        // Cancel request.
        A.AInt.emitCancel(state.pdfPreview.callID)
    } else {
        A.APDFPreview.cleanupFile(state.pdfPreview.source)
    }
    state.pdfPreview.resourceID = 0
    state.pdfPreview.runID = 0
    state.pdfPreview.source = ""
    state.pdfPreview.numPages = 0
}

//###############//
//### Product ###//
//###############//

function productCreateResumed(state) {
    A.ACamera.startStreams(L.Con.StreamType.Raw)
}

function productCreatePaused(state) {
    A.ACamera.stopStreams()
}

//--------------------------------------------

function productDetailResumed(state) {
    A.AProductDetail.load(state.productDetail.id)
    A.AProductDetail.loadRecentRunsNumEvents(state.productDetail.id, 25)
}

function productDetailDestroyed(state) {
    // Reset some state.
    state.productDetail.recentRuns = []
    state.productDetail.recentRunsNumEvents = []
}

//--------------------------------------------

function productOverviewResumed(state) {
    A.AProduct.loadAll()
}

//--------------------------------------------

function productRetrainResumed(state) {
    A.ACamera.startStreams(L.Con.StreamType.Raw)
}

function productRetrainPaused(state) {
    A.ACamera.stopStreams()
}

//###########//
//### Run ###//
//###########//

function runCreateDestroyed(state) {
    state.runCreate.preSelectedProductID = 0
}

//--------------------------------------------

function runDetailResumed(state) {
    A.ARunDetail.load(state.runDetail.id)
}

function runDetailDestroyed(state) {
    state.runDetail.skippedRunOverview = false
}

//--------------------------------------------

function runExportCreated(state) {
    // Request the storage devices, if configured.
    if (state.app.opts.withStorageDevices) {
        A.AGlobal.loadStorageDevices()
    }
}

function runExportDestroyed(state) {
    state.runExport.skippedRunDetail = false
}

//--------------------------------------------

function runOverviewDestroyed(state) {
    state.runOverview.skippedProductDetail = false
    state.runOverview.skippedProductName = ""
}

//--------------------------------------------

function runRecentDetailResumed(state) {
    A.ARunRecentDetail.load(state.runRecent.id)
}

//################//
//### Settings ###//
//################//

function settingsResumed(state) {
    A.ACamera.startStreams(L.Con.StreamType.Raw)
    A.ASettings.subscribeNetworkInterfaces()
}

function settingsPaused(state) {
    A.ACamera.stopStreams()
    A.ASettings.unsubscribeNetworkInterfaces(state.settings.networkInterfacesCallID)
}

//#############//
//### Setup ###//
//#############//

function setupCreated(state) {
    // Set the index to show the setup page as root in the breadcrumbs now.
    if (state.app.opts.withAutoLogin) {
        state.app.breadcrumbsStartIndex = 1
    }

    // Hide the settings in the toolbar.
    state.app.showSettings = false
}

function setupResumed(state) {
    A.ACamera.loadAll()
    A.ACamera.startStreams(L.Con.StreamType.Raw)

    // Request the storage devices files, if configured.
    if (state.app.opts.withStorageDevices) {
        A.AGlobal.loadStorageDevices()
        A.AGlobal.loadStorageDevicesFiles()
    }
}

function setupPaused(state) {
    A.ACamera.stopStreams()
    if (state.setup.motorTestDrive.callID > 0) {
        // Cancel request.
        A.ASetup.cancelTestCameraMotorTestDrive(state.setup.motorTestDrive.callID)
    }
}

function setupDestroyed(state) {
    // Show the settings in the toolbar.
    state.app.showSettings = true
}

//--------------------------------------------

function setupCameraMeasCalibCreated(state) {
    A.ACamera.startStream(state.setupCameraMeasCalib.cameraID, state.setupCameraMeasCalib.streamType)
}

function setupCameraMeasCalibDestroyed(state) {
    A.ACamera.stopStreams()
    state.setupCameraMeasCalib.streamType = L.Con.StreamType.Raw
}

//##############//
//### Status ###//
//##############//

function statusCreated(state) {
    // Set the index to show the status page as root in the breadcrumbs now.
    state.app.breadcrumbsStartIndex = 1
    // Show toolbar icons.
    state.app.showNotifications = true
    state.app.showSettings = true

    // Hide any toast messages when transitioning from the login stage.
    A.AAppToast.hide()
}

function statusResumed(state) {
    A.ACamera.startStreams(state.status.streamType)
}

function statusPaused(state) {
    A.ACamera.stopStreams()
}

function statusDestroyed(state) {
    // Reset to show login pages in the breadcrumbs again.
    state.app.breadcrumbsStartIndex = 0
    // Hide toolbar icons.
    state.app.showNotifications = false
    state.app.showSettings = false
}
