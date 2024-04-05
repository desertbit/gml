.pragma library

.import Dispatcher as D

// View the detail page of a run from the run overview page.
// Args:
//  - id(int) : The id of the run.
function viewFromRunOverview(id) {
    D.Dispatcher.dispatch(_type(viewFromRunOverview.name), { id: id })
}

// View the detail page of a run from the product detail page.
// Args:
//  - id(int) : The id of the run.
function viewFromProductDetail(id) {
    D.Dispatcher.dispatch(_type(viewFromProductDetail.name), { id: id })
}

//################//
//### Internal ###//
//################//

// Loads the run detail of the current run.
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
    return "runDetail" + funcName.capitalize()
}
