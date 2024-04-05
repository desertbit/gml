.pragma library

.import Dispatcher as D

// The user wants to create a new run.
function view() {
    D.Dispatcher.dispatch(_type(view.name), {})
}

// The user wants to create a new run from the given product.
// Args:
//  - productID(int) : The id of the product
function viewFromProductDetail(productID) {
    D.Dispatcher.dispatch(_type(viewFromProductDetail.name), { productID: productID })
}

// Generates a unique run name on the nLine device.
// Ret:
//  - Promise from dispatch
function generateUniqueRunName() {
    return D.Dispatcher.dispatch(_type(generateUniqueRunName.name), {}, true)
}

// Starts a new run.
// Args:
//  - productID(int)                      : The id of the product
//  - runName(string)                     : The name of the run
//  - sensitivityPreset(int)              : The preset to use
//  - customSensitivity(int)              : The sensitivity value, if a custom preset is used
//  - customSensitivityDiameterMin(float) : The minimum diameter, if a custom preset is used
//  - speed(float)                        : The fixed speed to use
//  - enableMeasurement(bool)             : Whether measurement is enabled
//  - diameterNorm(float)                 : The target value for the measurement
//  - diameterUpperDeviation(float)       : The maximum upper deviation from the target for the measurement
//  - diameterLowerDeviation(float)       : The maximum lower deviation from the target for the measurement
//  - measurementWidth(float)             : The width of the measurement
function start(
    productID, runName, sensitivityPreset, customSensitivity, customSensitivityDiameterMin, speed,
    enableMeasurement, diameterNorm, diameterUpperDeviation, diameterLowerDeviation, measurementWidth
) {
    D.Dispatcher.dispatch(_type(start.name), {
        productID: productID,
        runName: runName,
        sensitivityPreset: sensitivityPreset,
        customSensitivity: customSensitivity,
        customSensitivityDiameterMin: customSensitivityDiameterMin,
        speed: speed,
        enableMeasurement: enableMeasurement,
        diameterNorm: diameterNorm,
        diameterUpperDeviation: diameterUpperDeviation,
        diameterLowerDeviation: diameterLowerDeviation,
        measurementWidth: measurementWidth
    })
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
    return "runCreate" + funcName.capitalize()
}
