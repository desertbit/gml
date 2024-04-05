.pragma library

.import Dispatcher as D

// The user wants to logout from the nLine device.
function logout() {
    D.Dispatcher.dispatch(_type(logout.name), {})
}

//################//
//### Internal ###//
//################//

// nVision lost the connection to the nLine device.
function lostConnection() {
    D.Dispatcher.dispatch(_type(lostConnection.name), {})
}

//###############//
//### Private ###//
//###############//

// Returns the action type for the given function name of this script.
// Ret:
//  - string
function _type(funcName) {
    return "login" + funcName.capitalize()
}
