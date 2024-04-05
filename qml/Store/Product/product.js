.pragma library

.import Action as A
.import Lib as L

.import "../conv.js" as Conv

function removeOk(state, data) {
    const idx = state.products.findIndex(p => p.id === data.id)
    if (idx < 0) {
        return
    }

    // Remove the product.
    state.products.splice(idx, 1)

    // If the product is currently shown in the product detail page, pop it.
    if (state.app.pages[0] === L.Con.Page.ProductDetail) {
        A.ANavigation.popPage()
    }
}

//################//
//### Internal ###//
//################//

function loadAllOk(state, data) {
    state.products = data.products
    state.products.forEach(p => Conv.productFromGo(p))
}
