.pragma library

function loadSettings(app, type, data) {
    // Add data to the action.
    data.locale = app.settings.locale
    // Settings stores array elements as strings, convert back to integer.
    data.runActiveEventFilterCodes = app.settings.runActiveEventFilterCodes.map(c => parseInt(c))

    // Call the next handler.
    app.next(type, data)
}

function quit(app, action, type, data) {
    Qt.quit()

    app.consumed()
}

function switchLocale(app, type, data) {
    // Save new locale in settings.
    app.settings.locale = data.locale

    // Call next handler.
    app.next(type, data)
}

function showBusyDialog(app, type, data) {
    app.busyDialog.title = data.title
    app.busyDialog.text = data.text
    app.busyDialog.callID = data.callID
    app.busyDialog.open()

    app.consumed()
}

function hideBusyDialog(app, type, data) {
    app.busyDialog.close()

    app.consumed()
}

//################//
//### Internal ###//
//################//
