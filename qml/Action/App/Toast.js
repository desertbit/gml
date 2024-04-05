.pragma library

.import Dispatcher as D

// Display an error message via a Toast to the user.
// Args:
//  - msg(string) : The message that should be displayed.
function showError(msg) {
    D.Dispatcher.dispatch(_type("showMessage"), { type: "error", msg: msg })
}

// Display a warning message via a Toast to the user.
// Args:
//  - msg(string) : The message that should be displayed.
function showWarning(msg) {
    D.Dispatcher.dispatch(_type("showMessage"), { type: "warning", msg: msg })
}

// Display an info message via a Toast to the user.
// Args:
//  - msg(string) : The message that should be displayed.
function showInfo(msg) {
    D.Dispatcher.dispatch(_type("showMessage"), { type: "info", msg: msg })
}

// Display a success message via a Toast to the user.
// Args:
//  - msg(string) : The message that should be displayed.
function showSuccess(msg) {
    D.Dispatcher.dispatch(_type("showMessage"), { type: "success", msg: msg })
}

//################//
//### Internal ###//
//################//

// Hides the current toast message.
function hide() {
    D.Dispatcher.dispatch(_type(hide.name), {})
}

//###############//
//### Private ###//
//###############//

// Returns the action type for the given function name of this script.
// Ret:
//  - string
function _type(funcName) {
    return "appToast" + funcName.capitalize()
}
