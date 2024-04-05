.pragma library

.import Dispatcher as D

// Delete the runs with the given ids.
// Args:
//  - ids(array) : The ids of the runs
// Ret:
//  - dispatch promise on done
function remove(ids) {
    return D.Dispatcher.dispatch(_type(remove.name), { ids: ids }, true)
}

// Start the reclassification for the given run.
// Args:
//  - id(int) : The ids of the run
function startReclassify(id) {
    D.Dispatcher.dispatch(_type(startReclassify.name), { id: id })
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
    return "run" + funcName.capitalize()
}
