.pragma library

.import Action as A
.import Lib as L

function view(state, data) {
    state.loginConnect.addr = data.addr
    
    A.ANavigation.pushPage(L.Con.Page.LoginConnect)
}

//################//
//### Internal ###//
//################//

function start(state, data) {
    // Abort the current stream first.
    if (state.loginConnect.callID > 0) {
        A.AInternal.emitCancel(state.loginConnect.callID)
    }
    state.loginConnect.callID = data.callID
}

function startUpdate(state, data) {
    L.Obj.copyFrom(state.loginConnect, data)

    // Set special error flags.
    state.loginConnect.initializing = data.err === L.Con.Err.Initializing
    state.loginConnect.connectionRefused = data.err === L.Con.Err.ConnectFailed
}

function startOk(state, data) {
    state.loggedIn = true

    // Load default settings.
    A.ASettings.loadProductDefaultSettings()

    // Load app data.
    state.app.versionOutdated = data.versionOutdated
    if (data.versionOutdated) {
        A.ANotification.addUpdateAvailable()
    }

    // Load the motors.
    state.motorIDs = data.motorIDs

    // Load rest of device data into store.
    // We ignore all properties that do not exist in the state.
    L.Obj.copyFrom(state.nline, data)

    // Subscribe to the state data.
    A.AState.subscribe()

    // Request cameras.
    // Transition to status page.
    A.ACamera.loadAll().then(A.AStatus.viewFromConnect)
}
