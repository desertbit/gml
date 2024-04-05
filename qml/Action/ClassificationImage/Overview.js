/**
 * nLine
 * 
 * Copyright (c) 2023 Wahtari GmbH
 * All rights reserved
 */

.pragma library

.import Dispatcher as D

// View the classification images of the given product.
// Args:
//  - productID(int) : The id of the product
function view(productID) {
    D.Dispatcher.dispatch(_type(view.name), { productID: productID })
}

//################//
//### Internal ###//
//################//

// Load the classification image ids.
// Args:
//  - productID(int) : The id of the product
function load(productID) {
    D.Dispatcher.dispatch(_type(load.name), { productID: productID })
}

//###############//
//### Private ###//
//###############//

// Returns the action type for the given function name of this script.
// Ret:
//  - string
function _type(funcName) {
    return "classificationImageOverview" + funcName.capitalize()
}
