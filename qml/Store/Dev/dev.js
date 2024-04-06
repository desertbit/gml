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

function subscribeKunbusState(state, data) {
    // Abort the current stream first.
    if (state.dev.kunbus.callID > 0) {
        A.AInternal.emitCancel(state.dev.kunbus.callID)
    }

    state.dev.kunbus.callID = data.callID
}

function subscribeKunbusStateUpdate(state, data) {
    L.Obj.copyFrom(state.dev.kunbus, data)
}

function subscribeKunbusStateDone(state, data) {
    // Reset the data.
    L.Obj.copy(Init.InitState.dev.kunbus, state.dev.kunbus)
}
