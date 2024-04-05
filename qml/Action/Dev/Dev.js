/**
 * nLine
 * 
 * Copyright (c) 2023 Wahtari GmbH
 * All rights reserved
 */

.pragma library

.import Dispatcher as D

.import Action.Internal as AInternal

// Subscribes to updates to the kunbus state.
function subscribeKunbusState() {
    D.Dispatcher.dispatch(_type(subscribeKunbusState.name), {})
}

// Unsubscribes from updates to the kunbus state.
// Args:
//  - callID(int) : The id of the request to cancel
function unsubscribeKunbusState(callID) {
    AInternal.emitCancel(callID)
}

//###############//
//### Private ###//
//###############//

// Returns the action type for the given function name of this script.
// Ret:
//  - string
function _type(funcName) {
    return "dev" + funcName.capitalize()
}

