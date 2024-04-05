/**
 * nLine
 * 
 * Copyright (c) 2023 Wahtari GmbH
 * All rights reserved
 */

.pragma library

.import Dispatcher as D

// View the detail page of the classification image.
// Args:
//  - eventID(int)   : The id of the event to create the image for
//  - productID(int) : The id of the product
function view(eventID, productID) {
    D.Dispatcher.dispatch(_type(view.name), {
        eventID: eventID,
        productID: productID
    })
}

// Create the classification image.
// Args:
//  - eventID(int)              : The id of the event to create the image for
//  - runID(int)                : The id of the run
//  - productID(int)            : The id of the product
//  - boxToClassMapping(object) : A mapping of anomaly box ids to anomaly class ids
// Ret:
//  - dispatch promise
function create(eventID, runID, productID, boxToClassMapping) {
    return D.Dispatcher.dispatch(_type(create.name), {
        eventID: eventID,
        runID: runID,
        productID: productID,
        boxToClassMapping: boxToClassMapping
    }, true)
}

//################//
//### Internal ###//
//################//

// Loads the event for the given id.
// Args:
//  - eventID(int)   : The id of the event
//  - productID(int) : The id of the product
function loadEvent(eventID, productID) {
    D.Dispatcher.dispatch(_type(loadEvent.name), {
        eventID: eventID,
        productID: productID
    })
}

//###############//
//### Private ###//
//###############//

// Returns the action type for the given function name of this script.
// Ret:
//  - string
function _type(funcName) {
    return "classificationImageCreate" + funcName.capitalize()
}

