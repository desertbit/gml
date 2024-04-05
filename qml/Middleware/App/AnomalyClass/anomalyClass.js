.pragma library

.import Action as A
.import Lib as L
.import Store as S

function remove(app, type, data) {
    // Build a comma separated string list from the given ids.
    const classes = S.Store.state.anomalyClasses.filter(ac => data.ids.some(id => ac.id === id)).
                    reduce((acc, ac, i) => acc += (i === 0 ? "" : ", ") + `"${ac.name}"`, "")

    const title = qsTr("Delete %L1 class(es)").arg(data.ids.length)
    const message = qsTr("Are you sure you want to delete the selected class(es)?") + "\n" +
                    classes + "\n\n" +
                    qsTr("Every custom training image, that has no classes left afterwards, gets deleted from the product!") + "\n" +
                    qsTr("This action can not be undone!")
    app.deleteManyDialog.show(type, data, title, message)
}

function selectColorForClass(app, type, data) {
    app.colorDialog.show(color => {
        // Send the selected color with the action.
        data.color = color.toString()
        // Trigger the next action handler.
        app.next(type, data)
    })
}
