/**
 * nLine
 * 
 * Copyright (c) 2023 Wahtari GmbH
 * All rights reserved
 */

.pragma library

.import Store as S

function downloadNVisionAndRestart(app, type, data) {
    const title = qsTr("Download nVision update")
    const text = qsTr("Do you want to download and install version %1 now?").arg(S.Store.state.nline.nlineVersion) + "\n\n" +
                 qsTr("The application will close and restart automatically, once the update has been installed.")
    app.confirmDialog.show(type, data, title, text)
}