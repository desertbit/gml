/**
 * nLine
 * 
 * Copyright (c) 2023 Wahtari GmbH
 * All rights reserved
 */

.pragma library

function stopClassifyRuns(app, type, data) {
    const title = qsTr("Abort?")
    const text = qsTr("Do you want to abort the classification?")
    app.confirmDialog.show(type, data, title, text)
}

//################//
//### Internal ###//
//################//

function showErrorPopup(app, type, data) {
    app.stateErrPopup.open()

    app.consumed()
}
