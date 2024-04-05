.pragma library

.import View.Component.Toast as VCT

function showMessage(app, type, data) {
    app.toast.type = _stringTypeToToastType(data.type)
    app.toast.message = data.msg

    // Do not timeout the toast for error messages.
    // We want to ensure that the user actively dismisses the Toast.
    const isErr = data.type === "error"
    app.toast.timeout = isErr ? 0 : 5000
    app.toast.open()

    // Log errors additionally.
    if (isErr) {
        console.error(data.msg)
    }

    app.consumed()
}

//################//
//### Internal ###//
//################//

function hide(app, type, data) {
    app.toast.close()
    app.consumed()
}

//###############//
//### Private ###//
//###############//

// stringTypeToToastType returns the corresponding Toast.Type enum for the given string.
// Args:
//  - st(string) : The string representation for the enum.
// Ret:
//  - Toast.Type(enum)
function _stringTypeToToastType(st) {
    switch (st) {
    case "error":
        return VCT.Toast.Type.Error
    case "warning":
        return VCT.Toast.Type.Warning
    case "info":
        return VCT.Toast.Type.Info
    case "success":
        return VCT.Toast.Type.Success
    default:
        return -1
    }
}

