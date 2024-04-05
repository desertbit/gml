.pragma library

.import Action as A
.import Lib as L

.import "../conv.js" as Conv

function view(state, data) {
    if (L.State.isRun(state.nline.state)) {
        A.AAppToast.showInfo(qsTr("Another batch is already active. You need to finish it first."))
        return
    }
    if (state.nline.state !== L.State.Ready) {
        A.AAppToast.showInfo(qsTr("The nLine device must be in the 'Ready' state in order to start a new batch."))
        return
    }

    // Load the products first to check, if any are available at all to start a run.
    A.AProduct.loadAll().then(() => {
        if (state.products.length === 0) {
            A.AAppToast.showInfo(qsTr("No product yet available to start a batch, please create a new product first."))
        } else {
            A.ANavigation.pushPage(L.Con.Page.RunCreate)
        }
    })
}

//--------------------------------------------

function viewFromProductDetail(state, data) {
    if (L.State.isRun(state.nline.state)) {
        A.AAppToast.showInfo(qsTr("Another batch is already active. You need to finish it first."))
        return
    }
    if (state.nline.state !== L.State.Ready) {
        A.AAppToast.showInfo(qsTr("The nLine device must be in the 'Ready' state in order to start a new batch."))
        return
    }

    state.runCreate.preSelectedProductID = data.productID
    
    A.ANavigation.pushPage(L.Con.Page.RunCreate)
}

//--------------------------------------------

function start(state, data) {
    A.AApp.showBusyDialog(qsTr("Starting batch"), qsTr("This can take a few moments..."), data.callID)
}

//--------------------------------------------

function startOk(state, data) {
    // Return from the create run page.
    A.ANavigation.popPage()
}

function startDone(state, data) {
    // Hide the busy dialog.
    A.AApp.hideBusyDialog()
}

//################//
//### Internal ###//
//################//
