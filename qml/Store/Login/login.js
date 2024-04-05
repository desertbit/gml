/**
 * nLine
 * 
 * Copyright (c) 2023 Wahtari GmbH
 * All rights reserved
 */

.pragma library

.import Action as A
.import Lib as L

.import "../initState.js" as Init

function lostConnection(state, data) {
    // Go back to the login page.
    A.ANavigation.popToRoot()

    // Backup some properties that are app local and are only requested
    // once at application startup, or are independent of the nLine device
    // and should survive a connection loss.
    const locale = state.locale
    const pages = L.Obj.deepCopy(state.app.pages)
    const opts = L.Obj.deepCopy(state.app.opts)
    const showAdvancedOptions = state.app.showAdvancedOptions
    const eventCodes = L.Obj.deepCopy(state.runActive.filter.eventCodes)
    const addr = state.loginConnect.addr

    // Reset the state completely.
    L.Obj.copyFrom(state, Init.InitState)

    // Restore backup.
    state.locale = locale
    state.app.pages = pages
    state.app.opts = opts
    state.app.showAdvancedOptions = showAdvancedOptions
    state.runActive.filter.eventCodes = eventCodes
    state.loginConnect.addr = addr
}

//################//
//### Internal ###//
//################//
