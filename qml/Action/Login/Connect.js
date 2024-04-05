/**
 * nLine
 * 
 * Copyright (c) 2023 Wahtari GmbH
 * All rights reserved
 */

.pragma library

.import Dispatcher as D

.import Action.Internal as AInternal

// Display the connect page to connect with the given address.
// Args:
//  - addr(string)     : The address of the nLine device to connect to
function view(addr) {
    D.Dispatcher.dispatch(_type(view.name), { addr: addr })
}

//################//
//### Internal ###//
//################//

// A user wants to connect and login to the nLine device at addr.
// Try it repeatedly until the connect succeeds or the user aborts.
// Args:
//  - addr(string)     : The remote address to connect to
//  - username(string) : The name of the user
//  - password(string) : The password of the user
function start(addr, username, password) {
    D.Dispatcher.dispatch(_type(start.name), {
        addr: addr,
        username: username,
        password: password
    })
}

// Aborts the current login process.
// Args:
//  - callID(int) : The callID of the Api stream
function stop(callID) {
    AInternal.emitCancel(callID)
}

//###############//
//### Private ###//
//###############//

// Returns the action type for the given function name of this script.
// Ret:
//  - string
function _type(funcName) {
    return "loginConnect" + funcName.capitalize()
}
