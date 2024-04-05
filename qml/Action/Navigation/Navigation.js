/**
 * nLine
 * 
 * Copyright (c) 2023 Wahtari GmbH
 * All rights reserved
 */

.pragma library

.import Dispatcher as D

// Pushes a new page onto the stack.
// Args:
//  - page(enum) : The id of the page to push. See Lib.Con module for details.
function pushPage(page) {
    D.Dispatcher.dispatch(_type(pushPage.name), { page: page })
}

// Pops the current page from the stack.
// Args:
//  - num(int) : The number of pages to remove from the stack.
function popPage(num=1) {
    D.Dispatcher.dispatch(_type(popPage.name), { num: num })
}

// Replaces the current page with a new page.
// Args:
//  - page(enum) : The id of the page to push. See Lib.Con module for details.
//  - num(int)   : The number of pages to remove from the stack.
function replacePage(page, num=1) {
    D.Dispatcher.dispatch(_type(replacePage.name), { 
        page: page,
        num: num
    })
}

// Navigates back to the root of the stack.
function popToRoot() {
    D.Dispatcher.dispatch(_type(popToRoot.name), {})
}

//###############//
//### Private ###//
//###############//

// Returns the action type for the given function name of this script.
// Ret:
//  - string
function _type(funcName) {
    return "navigation" + funcName.capitalize()
}

