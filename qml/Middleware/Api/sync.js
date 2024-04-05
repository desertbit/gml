.pragma library

.import Action as A
.import Lib as L

// This file contains action handlers that call synchronous backend functions.
// We do not need 'Update' or 'Done' signal variants for them.

function appLoadRuntimeOptions(backend, root, type, data) {
    // Simply retrieve the options from the backend and
    // add them to the action data.
    // This function is executed synchronously.
    data.opts = JSON.parse(backend.appRuntimeOptions())

    // Call the next handler.
    root.next(type, data)
}

function appSwitchLocale(backend, root, type, data) {
    // Adjust language setting.
    const err = backend.appSwitchLocale(data.locale)
    if (!!err) {
        A.AAppToast.showError(`appSwitchLocale: ${err}`)

        // Consume the action, as it failed.
        root.consumed()
        return
    }

    // Call next handler.
    root.next(type, data)
}

function pdfPreviewCleanupFile(backend, root, type, data) {
    // Remove the pdf resource.
    const err = backend.pdfPreviewCleanupFile(data.path)
    if (!!err) {
        A.AAppToast.showError(`pdfPreviewCleanupFile: ${err}`)
    }

    // Consume the action in any case.
    root.consumed()
}
