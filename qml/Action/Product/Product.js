.pragma library

.import Dispatcher as D

// Remove a product with all of its runs, events, etc.
// Args:
//  - id(int) : The id of the product.
function remove(id) {
    D.Dispatcher.dispatch(_type(remove.name), { id: id })
}

//################//
//### Internal ###//
//################//

// Loads all products.
// Ret:
//  - Dispatch promise
function loadAll() {
    return D.Dispatcher.dispatch(_type(loadAll.name), {}, true)
}

//###############//
//### Private ###//
//###############//

// Returns the action type for the given function name of this script.
// Ret:
//  - string
function _type(funcName) {
    return "product" + funcName.capitalize()
}
