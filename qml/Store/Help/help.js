.pragma library

.import Action as A
.import Lib as L

function view(state, data) {
    // Help is accesible via the toolbar. We must prevent that the help page
    // can be created multiple times in the view stack.
    // When the help page is already part of the view stack, go back to it.
    const idx = state.app.pages.indexOf(L.Con.Page.Help)
    if (idx === -1) {
        A.ANavigation.pushPage(L.Con.Page.Help)
    } else {
        // Pop pages until the help page.
        A.ANavigation.popPage(idx)
    }
}

//################//
//### Internal ###//
//################//
