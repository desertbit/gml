.pragma library

.import Action as A
.import Lib as L

.import "../conv.js" as Conv

function view(state, data) {
    if (state.nline.state !== L.State.Ready) {
        A.AAppToast.showInfo(qsTr("The nLine device must be in the 'Ready' state to retrain a product."))
        return
    }

    state.productRetrain.productID = data.id

    A.ANavigation.pushPage(L.Con.Page.ProductRetrain)
}

//--------------------------------------------

function startOk(state, data) {
    A.AAppToast.showSuccess(qsTr("Product is being retrained.\nCheck the status page for the progress."))
    A.ANavigation.popPage()
}

//--------------------------------------------

//################//
//### Internal ###//
//################//
