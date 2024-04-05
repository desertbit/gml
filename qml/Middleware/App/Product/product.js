.pragma library

.import Action as A
.import Store as S

function remove(app, type, data) {
    app.deleteOneDialog.show(type, data, S.Store.state.products.find(p => p.id === data.id).name)
}
