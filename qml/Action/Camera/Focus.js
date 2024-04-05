/**
 * nLine
 * 
 * Copyright (c) 2023 Wahtari GmbH
 * All rights reserved
 */

.pragma library

.import Dispatcher as D
.import Lib as L

.import Action.Internal as AInternal

// View the camera focus page to adjust the current camera configuration.
function view() {
    D.Dispatcher.dispatch(_type(view.name), {})
}

// View the camera focus page from the ProductDetail page to adjust the 
// camera configuration of the product and save it permanently.
// Args:
//  - productID(int) : The id of the product
function viewFromProductDetail(productID) {
    D.Dispatcher.dispatch(_type(viewFromProductDetail.name), { productID: productID })
}

// Selects the given camera as the currently active one.
// Args:
//  - deviceID(string) : The device id of the camera.
function selectCamera(deviceID) {
    D.Dispatcher.dispatch(_type(selectCamera.name), { deviceID: deviceID })
}

// Saves the current camera focus configuration to the given product.
// Args:
//  - productID(int) : The id of the product
function saveToProduct(productID) {
    D.Dispatcher.dispatch(_type(saveToProduct.name), { productID: productID })
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
    return "cameraFocus" + funcName.capitalize()
}
