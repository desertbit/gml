.pragma library

.import Dispatcher as D

// Resets the state of the nLine device to the ready state.
function resetError() {
    D.Dispatcher.dispatch(_type(resetError.name), {})
}

// Stops the current run classification.
function stopClassifyRuns() {
    D.Dispatcher.dispatch(_type(stopClassifyRuns.name), {})
}

//################//
//### Internal ###//
//################//

// Displays the state error popup that describes the current error state to the user
// and offers him to acknowledge it.
function showErrorPopup() {
    D.Dispatcher.dispatch(_type(showErrorPopup.name), {})
}

// Subscribes to state changes of the nLine device.
function subscribe() {
    D.Dispatcher.dispatch(_type(subscribe.name), {})
}

//###############//
//### Private ###//
//###############//

// Returns the action type for the given function name of this script.
// Ret:
//  - string
function _type(funcName) {
    return "state" + funcName.capitalize()
}
