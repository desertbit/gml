.pragma library

.import Action as A
.import Lib as L

function loadRuntimeOptions(state, data) {
    L.Obj.copyFrom(state.app.opts, data.opts)

    // Emit a navigation action to load the first page.
    if (data.opts.withAutoLogin) {
        A.ALoginConnect.view(state.app.opts.autoLoginAddr)
    } else {
        A.ANavigation.pushPage(L.Con.Page.LoginDiscovery)
    }
}

function loadSettings(state, data) {
    // Load state.
    state.locale = data.locale
    state.runActive.filter.eventCodes = data.runActiveEventFilterCodes

    // Trigger a new action so that the locale gets loaded.
    A.AApp.switchLocale(state.locale)
}

function switchLocale(state, data) {
    state.locale = data.locale
}

function setOptions(state, data) {
    L.Obj.copyFrom(state.app.opts, data)
}

function showAdvancedOptions(state, data) {
    state.app.showAdvancedOptions = true
}

function setAdvancedOptions(state, data) {
    L.Obj.copyFrom(state.app.opts, data)
}

function hideAdvancedOptions(state, data) {
    state.app.showAdvancedOptions = false
}

//################//
//### Internal ###//
//################//
