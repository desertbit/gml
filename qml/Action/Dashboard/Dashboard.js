.pragma library

.import Dispatcher as D

.import Action.Internal as AInternal

// User wants to view the dashboard page.
function view() {
    D.Dispatcher.dispatch(_type(view.name), {})
}

//################//
//### Internal ###//
//################//

// Subscribe to the live device stats.
function subscribeStats() {
    D.Dispatcher.dispatch(_type(subscribeStats.name), {})
}

// Unsubscribe from the live device stats.
// Args:
//  - callID(int) : The callID of the Api stream.
function unsubscribeStats(callID) {
    AInternal.emitCancel(callID)
}

//###############//
//### Private ###//
//###############//

// Returns the action type for the given function name of this script.
// Ret:
//  - string
function _type(funcName) {
    return "dashboard" + funcName.capitalize()
}
