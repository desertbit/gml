/**
 * nLine
 * 
 * Copyright (c) 2023 Wahtari GmbH
 * All rights reserved
 */

.pragma library

.import Dispatcher as D
.import Lib as L

// View the training images of the given product.
// Args:
//  - productID(int) : The id of the product
function view(productID) {
    D.Dispatcher.dispatch(_type(view.name), { productID: productID })
}

// Remove the train images of the product.
// Args:
//  - productID(int) : The id of the product
//  - imageIDs(int)  : The ids of the images that should be removed
// Ret:
//  - dispatch promise
function remove(productID, imageIDs) {
    return D.Dispatcher.dispatch(_type(remove.name), {
        productID: productID,
        imageIDs: imageIDs
    }, true)
}

//################//
//### Internal ###//
//################//

// Load the train image ids.
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
    return "productTrainImages" + funcName.capitalize()
}
