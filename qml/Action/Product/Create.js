.pragma library

.import Dispatcher as D

// The user wants to create a new product.
function view() {
    D.Dispatcher.dispatch(_type(view.name), {})
}

// Starts creating a new product.
// Args:
//  - name(string)        : The name of the new product.
//  - description(string) : The description of the new product.
//  - preset(int)         : The sensitivity preset of the new product.
//  - sensitivity(int)    : The sensitivity of the new product.
//  - minDiameter(bool)   : The sensitivity min diameter of the new product.
//  - cameraSetup(bool)   : Whether the cameras should be set up.
function start(name, description, preset, sensitivity, minDiameter, cameraSetup) {
    D.Dispatcher.dispatch(_type(start.name), {
        name: name,
        sensitivityPreset: preset,
        customSensitivity: sensitivity,
        customSensitivityDiameterMin: minDiameter,
        description: description,
        cameraSetup: cameraSetup
    })
}

// Stops an ongoing create product operation.
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
    return "productCreate" + funcName.capitalize()
}
