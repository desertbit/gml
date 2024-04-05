.pragma library

.import Dispatcher as D

// Navigate to the product overview page.
function view() {
    D.Dispatcher.dispatch(_type(view.name), {})
}

//################//
//### Internal ###//
//################//

//###############//
//### Private ###//
//###############//

// Returns the action type for the given function name of this script.
// Ret:
//  - string
function _type(funcName) {
    return "productOverview" + funcName.capitalize()
}
