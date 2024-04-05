.pragma library

.import Dispatcher as D

// View the detail page of a recent run.
// Args:
//  - id(int) : The id of the run.
function view(id) {
    D.Dispatcher.dispatch(_type(view.name), { id: id })
}

//################//
//### Internal ###//
//################//

// Loads the run detail of the current recent run.
// Args:
//  - id(int) : The id of the run.
function load(id) {
    D.Dispatcher.dispatch(_type(load.name), {
        id: id,
        eventsLimit: 25,
        numEventAggregations: 100,
        numMeasureAggregations: 100,
    })
}

//###############//
//### Private ###//
//###############//

// Returns the action type for the given function name of this script.
// Ret:
//  - string
function _type(funcName) {
    return "runRecentDetail" + funcName.capitalize()
}
