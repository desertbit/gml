.pragma library

.import Action as A
.import Lib as L

.import "../conv.js" as Conv

function view(state, data) {
    if (state.nline.state !== L.State.Ready) {
        A.AAppToast.showInfo(qsTr("The nLine device must be in the 'Ready' state to create a new product."))
        return
    }

    // Load default settings.
    A.ASettings.loadProductDefaultSettings()
    // Load the products so the Create page can validate the product name.
    A.AProduct.loadAll()
    // Push the create page.
    A.ANavigation.pushPage(L.Con.Page.ProductCreate)
}

//--------------------------------------------

function startOk(state, data) {
    // Go back from Create product page.
    A.ANavigation.popPage()
}

//################//
//### Internal ###//
//################//
