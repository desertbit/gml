/**
 * nLine
 * 
 * Copyright (c) 2023 Wahtari GmbH
 * All rights reserved
 */

function startSpool() {
    A.ARunCreate.start(
        productPane.productID,
        runPane.name,
        sensitivityPane.preset,
        sensitivityPane.sensitivity,
        sensitivityPane.minDiameter,
        runPane.speed,
        measurementPane.enableMeasurement,
        measurementPane.diameterNorm,
        measurementPane.diameterUpperDeviation,
        measurementPane.diameterLowerDeviation,
        measurementPane.measurementWidth
    )
}

function productSelected() {
    // Load the product's properties into the other panes.
    loadSensitivityDefaults()
    loadMeasurementDefaults()
    loadRunDataDefaults()
}

function loadSensitivityDefaults() {
    // Load the default values from the selected product.
    const p = productPane.product
    sensitivityPane.preset = p.sensitivityPreset
    sensitivityPane.sensitivity = p.customSensitivity || L.Con.MinRecommendedSensitivity
    sensitivityPane.minDiameter = p.customSensitivityDiameterMin
}

function loadMeasurementDefaults() {
    // Load the default values from the selected product.
    const p = productPane.product
    measurementPane.enableMeasurement = p.enableMeasurement
    measurementPane.diameterNorm = p.diameterNorm
    measurementPane.diameterUpperDeviation = p.diameterUpperDeviation
    measurementPane.diameterLowerDeviation = p.diameterLowerDeviation
    measurementPane.measurementWidth = p.measurementWidth
}

function loadRunDataDefaults() {
    // Load the default values from the selected product.
    const p = productPane.product
    // Make sure that the speed is only set if it has any value.
    runPane.defaultSpeed = p.defaultSpeed > 0 ? p.defaultSpeed / 100 : "" // Value must be converted from cm to m.
}
