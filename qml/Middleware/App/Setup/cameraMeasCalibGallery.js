/**
 * nLine
 * 
 * Copyright (c) 2024 Wahtari GmbH
 * All rights reserved
 */

.pragma library

.import Action as A
.import Store as S

function remove(app, type, data) {
    const title = qsTr("Delete %L1 measurement calibration image(s)").arg(data.imageIDs.length)
    const message = qsTr("Are you sure you want to delete the selected %L1 measurement calibration image(s)?").arg(data.imageIDs.length) + "\n" +
                    qsTr("This action can not be undone!")
    app.deleteManyDialog.show(type, data, title, message)
}