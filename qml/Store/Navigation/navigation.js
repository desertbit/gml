.pragma library

.import Action as A
.import Lib as L

.import "../page.js" as P

function pushPage(state, data) {
    // Call state function for the paused page.
    if (state.app.pages.length > 0) {
        _callCurrentPagePausedFuncIfDefined(state)
    }

    // Add current page to the front.
    state.app.pages.unshift(data.page)

    // Call state functions for newly pushed page.
    _callCurrentPageCreatedFuncIfDefined(state)
    _callCurrentPageResumedFuncIfDefined(state)
}

//--------------------------------------------

function popPage(state, data) {
    if (state.app.pages.length === 1) {
        // Already at root.
        return
    }

    // Call state function for the paused page.
    _callCurrentPagePausedFuncIfDefined(state)

    // Pop as many pages as requested.
    for (let i = 0; i < data.num; ++i) {
        // Call state functions for destroyed pages.
        _callCurrentPageDestroyedFuncIfDefined(state)

        // Remove topmost page.
        state.app.pages.shift()
    }

    // Call state function for the resumed page.
    _callCurrentPageResumedFuncIfDefined(state)
}

//--------------------------------------------

function replacePage(state, data) {
    // Call state functions for the paused page.
    _callCurrentPagePausedFuncIfDefined(state)

    // Remove as many pages as requested.
    for (let i = 0; i < data.num; ++i) {
        // Call state functions for destroyed pages.
        _callCurrentPageDestroyedFuncIfDefined(state)

        // Remove topmost page.
        state.app.pages.shift()
    }

    // Add new page to the front.
    state.app.pages.unshift(data.page)

    // Call state functions for the created page.
    _callCurrentPageCreatedFuncIfDefined(state)
    _callCurrentPageResumedFuncIfDefined(state)
}

//--------------------------------------------

function popToRoot(state, data) {
    if (state.app.pages.length === 1) {
        // Already at root.
        return
    }

    // Pop all pages until the root page.
    const num = state.app.pages.length - 1
    
    // Call state function for the paused page.
    _callCurrentPagePausedFuncIfDefined(state)

    for (let i = 0; i < num; ++i) {
        // Call state functions for the destroyed pages.
        _callCurrentPageDestroyedFuncIfDefined(state)

        // Remove topmost page.
        state.app.pages.shift()
    }

    // Call state function for the resumed page.
    _callCurrentPageResumedFuncIfDefined(state)
}

//###############//
//### Private ###//
//###############//

function _callCurrentPageCreatedFuncIfDefined(state) {
    _callPageFuncIfDefined(`${state.app.pages[0]}Created`, state)
}

function _callCurrentPageResumedFuncIfDefined(state) {
    _callPageFuncIfDefined(`${state.app.pages[0]}Resumed`, state)
}

function _callCurrentPagePausedFuncIfDefined(state) {
    _callPageFuncIfDefined(`${state.app.pages[0]}Paused`, state)
}

function _callCurrentPageDestroyedFuncIfDefined(state) {
    _callPageFuncIfDefined(`${state.app.pages[0]}Destroyed`, state)
}

function _callPageFuncIfDefined(name, state) {
    if (L.Obj.hasFunc(P, name)) {
        P[name](state)
    }
}
