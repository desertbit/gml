.pragma library

.import Action as A
.import Store as S

function remove(app, type, data) {
    const title = qsTr("Delete %L1 batch(es)").arg(data.ids.length)
    const message = qsTr("Are you sure you want to delete the selected %L1 batch(es)?").arg(data.ids.length) + "\n" +
                    qsTr("This action can not be undone!")
    app.deleteManyDialog.show(type, data, title, message)
}
