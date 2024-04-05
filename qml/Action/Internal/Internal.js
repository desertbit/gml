.pragma library

.import Dispatcher as D
.import Lib as L

// Emits a cancel action to abort asynchronous, running actions.
// Useful to abort network requests.
// Args:
//  - callID(int) : The callID created by the Api middleware
function emitCancel(callID) {
    D.Dispatcher.dispatch("cancel", { callID: callID })
}

// Emits an action with the given type and the suffix 'Done' appended to it.
// Useful for actions that need to perform async tasks.
// Args:
//  - type(string) : The action type
//  - data(object) : The action data
function emitDone(type, data) {
    D.Dispatcher.dispatch(`${type}Done`, data)
}

// Emits an action with the given type and the suffix 'Update' appended to it.
// Useful for actions that trigger multiple updates.
// Args:
//  - type(string) : The action type
//  - data(object) : The action data
function emitUpdate(type, data) {
    D.Dispatcher.dispatch(`${type}Update`, data)
}
