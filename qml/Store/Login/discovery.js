.pragma library

.import Action as A

function search(state, data) {
    // Abort the current stream first.
    if (state.loginDiscovery.callID > 0) {
        A.AInternal.emitCancel(state.loginDiscovery.callID)
    }

    state.loginDiscovery.callID = data.callID
}

function searchUpdate(state, data) {
    state.loginDiscovery.devices = data.devices
}

function searchDone(state, data) {
    state.loginDiscovery.callID = 0
}

//################//
//### Internal ###//
//################//
