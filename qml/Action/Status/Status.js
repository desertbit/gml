.pragma library

.import Dispatcher as D

// View the status page from the connect page.
function viewFromConnect() {
    D.Dispatcher.dispatch(_type(viewFromConnect.name), {})
}

// Sets the stream type on the status page.
// Args:
//  - streamType(enum) : The type of stream.
function setStreamType(streamType) {
    D.Dispatcher.dispatch(_type(setStreamType.name), { streamType: streamType })
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
    return "status" + funcName.capitalize()
}
