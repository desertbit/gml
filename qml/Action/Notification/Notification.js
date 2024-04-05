.pragma library

.import Dispatcher as D

// Should be called, when the notifications are displayed to the user.
function markRead() {
    D.Dispatcher.dispatch(_type(markRead.name), {})
}

//################//
//### Internal ###//
//################//

// Adds a new notification item that displays the progress of a task.
// Args:
//  - type(enum)  : The type of the notification. See Lib.constants
//  - callID(int) : The callID of the associated Api middleware request
function addProgress(type, callID) {
    D.Dispatcher.dispatch(_type(addProgress.name), {
        type: type,
        callID: callID
    })
}

// Updates the progress of the notification item with the given callID.
// Args:
//  - callID(int)     : The callID of the associated Api middleware request
//  - progress(float) : The new progress value of the item
function updateProgress(callID, progress) {
    D.Dispatcher.dispatch(_type(updateProgress.name), {
        callID: callID,
        progress: progress
    })
}

// Removes the notification progress item with the given callID.
// Args:
//  - callID(int)     : The callID of the associated Api middleware request
function removeProgress(callID) {
    D.Dispatcher.dispatch(_type(removeProgress.name), { callID: callID })
}

// Adds a new notification item showing that an update of nVision is available.
function addUpdateAvailable() {
    D.Dispatcher.dispatch(_type(addUpdateAvailable.name), {})
}

//###############//
//### Private ###//
//###############//

// Returns the action type for the given function name of this script.
// Ret:
//  - string
function _type(funcName) {
    return "notification" + funcName.capitalize()
}

