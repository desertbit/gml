.pragma library

.import Action as A
.import Lib as L

function view(state, data) {
    A.ASettings.load()
    
    // Load default settings.
    A.ASettings.loadProductDefaultSettings()

    // Settings are accesible via the toolbar. We must prevent that the settings page
    // can be created multiple times in the view stack.
    // When the settings page is already part of the view stack, go back to it.
    const idx = state.app.pages.indexOf(L.Con.Page.Settings)
    if (idx === -1) {
        A.ANavigation.pushPage(L.Con.Page.Settings)
    } else {
        // Pop pages until the settings page.
        A.ANavigation.popPage(idx)
    }
}

//--------------------------------------------

function updateNetworkOk(state, data) {
    L.Obj.copyFrom(state.settings.network, data)
}

//--------------------------------------------

function setAutofocusBeforeStartRunOk(state, data) {
    state.settings.autofocusBeforeStartRun = data.enabled
}

//--------------------------------------------

function setCamerasFlipStateOk(state, data) {
    state.settings.camerasFlipState = data.state
}

//--------------------------------------------

function setAlertAndPauseOk(state, data) {
    state.settings.alertAndPauseEnabled = data.enabled
    state.settings.alertAndPauseEventCodes = data.eventCodes
}

function updateDefaultProductSettingsDone(state, data) {
    state.productDefaultSettings.sensitivityPreset = data.sensitivityPreset
    state.productDefaultSettings.customSensitivity = data.customSensitivity
    state.productDefaultSettings.customSensitivityDiameterMin = data.customSensitivityDiameterMin
}

function loadProductDefaultSettingsDone(state, data) {
    state.productDefaultSettings.sensitivityPreset = data.sensitivityPreset
    state.productDefaultSettings.customSensitivity = data.customSensitivity
    state.productDefaultSettings.customSensitivityDiameterMin = data.customSensitivityDiameterMin
}

//################//
//### Internal ###//
//################//

function loadOk(state, data) {
    // Keep the default value, if the event codes are not yet defined.
    if (data.alertAndPauseEventCodes === null) {
        delete data.alertAndPauseEventCodes
    }
    L.Obj.copyFrom(state.settings, data)
}

//--------------------------------------------

function subscribeNetworkInterfaces(state, data) {
    // Abort the current stream first.
    if (state.settings.networkInterfacesCallID > 0) {
        A.AInt.emitCancel(state.settings.networkInterfacesCallID)
    }

    state.settings.networkInterfacesCallID = data.callID
}

function subscribeNetworkInterfacesUpdate(state, data) {
    state.settings.networkInterfaces = data.interfaces
}

function subscribeNetworkInterfacesDone(state, data) {
    state.settings.networkInterfaces = []
}