/**
 * nLine
 * 
 * Copyright (c) 2023 Wahtari GmbH
 * All rights reserved
 */

.pragma library

function remove(app, type, data) {
    const title = qsTr("Delete %L1 classification image(s)").arg(data.imageIDs.length)
    const message = qsTr("Are you sure you want to delete the selected classification image(s)?") + "\n" +
                    qsTr("This action can not be undone!")
    app.deleteManyDialog.show(type, data, title, message)
}
