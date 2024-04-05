.pragma library

.import Dispatcher as D

// Navigate to the product detail page.
// Args:
//  - id(int) : The id of the product.
function view(id) {
    D.Dispatcher.dispatch(_type(view.name), { id: id })
}

// Loads the number of events of the most recent runs of the product.
// Args:
//  - id(int)    : The id of the product.
//  - limit(int) : The maximum number of recent runs to request the number of events for.
//                 0 means no limit.
function loadRecentRunsNumEvents(id, limit) {
    D.Dispatcher.dispatch(_type(loadRecentRunsNumEvents.name), {
        id: id,
        limit: limit
    })
}

// Edit the current product and navigate to the edit product page.
function edit() {
    D.Dispatcher.dispatch(_type(edit.name), {})
}

// Updates the current product.
// Args:
//  - product(object) : The product object containing the changes.
function update(product) {
    D.Dispatcher.dispatch(_type(update.name), product)
}

// Starts the reclassification of all runs of the given product.
// Args:
//  - id(int) : The id of the product
function startReclassifyAllRuns(id) {
    D.Dispatcher.dispatch(_type(startReclassifyAllRuns.name), { id: id })
}

//################//
//### Internal ###//
//################//

// Load the detailed information about the product with the given id.
// Args:
//  - id(int)              : The id of the product.
//  - recentRunsLimit(int) : The maximum number of recent runs to request.
function load(id, recentRunsLimit=20) {
    D.Dispatcher.dispatch(_type(load.name), {
        id: id,
        recentRunsLimit: recentRunsLimit
    })
}

//###############//
//### Private ###//
//###############//

// Returns the action type for the given function name of this script.
// Ret:
//  - string
function _type(funcName) {
    return "productDetail" + funcName.capitalize()
}
