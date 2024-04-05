.pragma library

.import Dispatcher as D

.import Action.Internal as AInternal

//################//
//### Internal ###//
//################//

// Starts the discovery of nLine devices connected to the same network.
// This will refresh the devices regularly until the discovery is stopped.
function search() {
    D.Dispatcher.dispatch(_type(search.name), {})
}

// Stops the discovery of nLine devices.
// Args:
//  - callID(int) : The callID of the Api stream.
function stopSearch(callID) {
    AInternal.emitCancel(callID)
}

//###############//
//### Private ###//
//###############//

// Returns the action type for the given function name of this script.
// Ret:
//  - string
function _type(funcName) {
    return "loginDiscovery" + funcName.capitalize()
}
