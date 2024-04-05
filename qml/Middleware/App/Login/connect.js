.pragma library

.import Action as A
.import Store as S

function startDone(app, type, data) {
    if (data.api.ok && data.versionIncompatible) {
        const title = qsTr("Update required")
        const text = qsTr("This nVision version is not compatible with the nLine device.") + "\n\n" +
                     qsTr("Current version: '%1'").arg(Qt.application.version) + "\n" +
                     qsTr("nLine version: '%1'").arg(data.nlineVersion) + "\n\n" + 
                     qsTr("Do you want to download and install the update now?")

        // Connect to the signals of the dialog.
        // Make sure to disconnect again on trigger so we do not stack multiple 
        // triggers whenever we show this dialog.
        app.updateRequiredDialog.confirmed.connect(function cb(type, data) {
            app.updateRequiredDialog.confirmed.disconnect(cb)

            // Download the update.
            A.AGlobal.downloadNVisionAndRestart()
        })
        app.updateRequiredDialog.denied.connect(function cb() {
            app.updateRequiredDialog.denied.disconnect(cb)

            if (S.Store.state.app.pages.length > 1) {
                // The Connect page is not the only page.
                // This means, the user has selected this nLine device on purpose.
                // Navigate back to the disovery page in this case.
                A.ANavigation.popPage()
            } else {
                // Quit, nVision can not connect to an incompatible nLine device.
                A.AApp.quit()
            }
        })
        app.updateRequiredDialog.show(type, data, title, text)

        // The action can be consumed here.
        // The user must either download the update or quit nVision / leave the Connect page.
        app.consumed()
        return
    }

    // Call next handler.
    app.next(type, data)
}

//################//
//### Internal ###//
//################//
