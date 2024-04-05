/**
 * nLine
 * 
 * Copyright (c) 2023 Wahtari GmbH
 * All rights reserved
 */

.pragma library

function shutdownNLine(app, type, data) {
    const title = qsTr("Shutdown nLine")
    const text = qsTr("Do you want to shutdown the nLine device now?")
    app.confirmDialog.show(type, data, title, text)
}

function rebootNLine(app, type, data) {
    const title = qsTr("Reboot nLine")
    const text = qsTr("Do you want to reboot the nLine device now?")
    app.confirmDialog.show(type, data, title, text)
}
