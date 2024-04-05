/**
 * nLine
 * 
 * Copyright (c) 2023 Wahtari GmbH
 * All rights reserved
 */

.pragma library

function stop(app, type, data) {
    const title = qsTr("Abort?")
    const text = qsTr("Do you want to abort the creation of the new product?")
    app.confirmDialog.show(type, data, title, text)
}