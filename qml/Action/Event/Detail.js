.pragma library

.import Dispatcher as D

// View the detail page of an event from one of the run detail pages.
// Args:
//  - id(int)        : The id of the event
//  - runID(int)     : The id of the run
//  - productID(int) : The id of the associated product
function viewFromRunDetail(id, runID, productID) {
    D.Dispatcher.dispatch(_type(viewFromRunDetail.name), {
        id: id,
        runID,
        productID: productID
    })
}

// View the detail page of an event from the status page.
// Args:
//  - id(int)        : The id of the event
//  - runID(int)     : The id of the run
//  - productID(int) : The id of the associated product
function viewFromStatus(id, runID, productID) {
    D.Dispatcher.dispatch(_type(viewFromStatus.name), {
        id: id,
        runID,
        productID: productID
    })
}

// View the detail page of an event.
// Args:
//  - id(int)                : The id of the event
//  - runID(int)             : The id of the run
//  - productID(int)         : The id of the associated product
//  - afterTS(date)          : Filter excluding events before this date
//  - beforeTS(date)         : Filter excluding events after this date
//  - eventCodes(array)      : Filter, array of event codes
//  - anomalyClassIDs(array) : Filter, array of anomaly class ids
function viewFromOverview(id, runID, productID, afterTS, beforeTS, eventCodes, anomalyClassIDs) {
    D.Dispatcher.dispatch(_type(viewFromOverview.name), {
        id: id,
        runID,
        productID: productID,
        afterTS: afterTS,
        beforeTS: beforeTS,
        eventCodes: eventCodes,
        anomalyClassIDs: anomalyClassIDs
    })
}

// View the detail page of the next event after the current event.
function viewNext() {
    D.Dispatcher.dispatch(_type(viewNext.name), {})
}

// View the detail page of the previous event before the current event.
function viewPrev() {
    D.Dispatcher.dispatch(_type(viewPrev.name), {})
}

// Create a classification image from the current event with the given box to class mapping.
// Args:
//  - id(int)                   : The id of the event
//  - runID(int)                : The id of the run
//  - productID(int)            : The id of the product
//  - boxToClassMapping(object) : A mapping of boxIDs to classIDs
function createClassificationImage(id, runID, productID, boxToClassMapping) {
    D.Dispatcher.dispatch(_type(createClassificationImage.name), {
        id: id,
        runID: runID,
        productID: productID,
        boxToClassMapping: boxToClassMapping
    })
}

//################//
//### Internal ###//
//################//

// Load the event detail data.
// Args:
//  - id(int)                : The id of the event
//  - runID(int)             : The id of the run
//  - productID(int)         : The id of the product
//  - afterTS(date)          : Filter excluding events before this date
//  - beforeTS(date)         : Filter excluding events after this date
//  - eventCodes(array)      : Filter, array of event codes
//  - anomalyClassIDs(array) : Filter, array of anomaly class ids
function load(id, runID, productID, afterTS, beforeTS, eventCodes, anomalyClassIDs) {
    D.Dispatcher.dispatch(_type(load.name), {
        id: id,
        runID: runID,
        productID: productID,
        afterTS: afterTS,
        beforeTS: beforeTS,
        eventCodes: eventCodes,
        anomalyClassIDs: anomalyClassIDs
    })
}

//###############//
//### Private ###//
//###############//

// Returns the action type for the given function name of this script.
// Ret:
//  - string
function _type(funcName) {
    return "eventDetail" + funcName.capitalize()
}
