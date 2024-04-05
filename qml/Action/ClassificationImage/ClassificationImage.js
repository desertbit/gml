/**
 * nLine
 * 
 * Copyright (c) 2023 Wahtari GmbH
 * All rights reserved
 */

.pragma library

.import Dispatcher as D

// Remove the classification images of the product.
// Args:
//  - productID(int)  : The id of the product
//  - imageIDs(array) : The ids of the images that should be removed
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

//###############//
//### Private ###//
//###############//

// Returns the action type for the given function name of this script.
// Ret:
//  - string
function _type(funcName) {
    return "classificationImage" + funcName.capitalize()
}
