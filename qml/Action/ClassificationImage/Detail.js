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
//  - id(int) : The id of the classification image
function view(id) {
    D.Dispatcher.dispatch(_type(view.name), { id: id })
}

// View the detail page of the classification image from its origin event detail page.
// Args:
//  - eventID(int) : The id of the event
function viewFromEvent(eventID) {
    D.Dispatcher.dispatch(_type(viewFromEvent.name), { eventID: eventID })
}

// Updates the classes of the given classification image to the new mapping.
// Args:
//  - id(int)                   : The id of the classification image
//  - boxToClassMapping(object) : A mapping of boxIDs to classIDs
// Ret:
//  - dispatch promise
function updateClasses(id, boxToClassMapping) {
    return D.Dispatcher.dispatch(_type(updateClasses.name), {
        id: id,
        boxToClassMapping: boxToClassMapping
    }, true)
}

// View the detail page of the next classification image after the current one.
function viewNext() {
    D.Dispatcher.dispatch(_type(viewNext.name), {})
}

// View the detail page of the previous classification image before the current one.
function viewPrev() {
    D.Dispatcher.dispatch(_type(viewPrev.name), {})
}

//################//
//### Internal ###//
//################//

// Load the classification image with the given id.
// Args:
//  - id(int) : The id of the classification image
function load(id) {
    D.Dispatcher.dispatch(_type(load.name), { id: id })
}

// Load the classification image that originates from the given event.
// Args:
//  - eventID(int) : The id of the event
function loadFromEvent(eventID) {
    D.Dispatcher.dispatch(_type(loadFromEvent.name), { eventID: eventID })
}

//###############//
//### Private ###//
//###############//

// Returns the action type for the given function name of this script.
// Ret:
//  - string
function _type(funcName) {
    return "classificationImageDetail" + funcName.capitalize()
}
