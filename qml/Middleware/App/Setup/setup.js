/**
 * nLine
 * 
 * Copyright (c) 2024 Wahtari GmbH
 * All rights reserved
 */

.pragma library

function exportData(app, type, data) {
    // Open the native system file dialog and let the user choose a path.
    app.fileDialog.selectExisting = false
    app.fileDialog.selectFolder = false
    app.fileDialog.cb = function(fileUrls) {
        if (fileUrls.length === 0) {
            app.consumed()
            return
        }

        data.path = fileUrls[0].toString()
        app.next(type, data)
    }
    app.fileDialog.open()
}

//--------------------------------------------

function importData(app, type, data) {
    // Open the native system file dialog and let the user choose a path.
    app.fileDialog.selectExisting = true
    app.fileDialog.selectFolder = false
    app.fileDialog.nameFilters = [ "Setup data (*.tar)", "All files (*)" ]
    app.fileDialog.cb = function(fileUrls) {
        if (fileUrls.length === 0) {
            app.consumed()
            return
        }

        data.path = fileUrls[0].toString()
        app.next(type, data)
    }
    app.fileDialog.open()
}
