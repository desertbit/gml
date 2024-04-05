.pragma library

.import Dispatcher as D

// The user wants to retrain an existing product.
function view(id) {
    D.Dispatcher.dispatch(_type(view.name), { id: id })
}

// Starts retraining an existing product.
// Args:
//  - id(int)               : The id of the product
//  - cameraSetup(bool)     : Whether the cameras should be set up for recollection
//  - recollectImages(bool) : Whether new images should be collected
function start(id, cameraSetup, recollectImages) {
    D.Dispatcher.dispatch(_type(start.name), {
        id: id,
        cameraSetup: cameraSetup,
        recollectImages: recollectImages
    })
}

// Stops an ongoing Retrain product operation.
function stop() {
    D.Dispatcher.dispatch(_type(stop.name), {})
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
    return "productRetrain" + funcName.capitalize()
}
