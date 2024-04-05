import QtQuick
import QtQuick.Controls

import Action as A
import Lib as L

import View.Component.Dialog as VCD

import "../Base"

import "sync.js" as SyncHandler

// The API middleware handles requests against the backend API.
// To handle a certain action, simply add a function with the same name to one of the handler scripts.
//
// A handler function must have the following signature:
//
//    function <action-type>(Actions, backend, req, data) -> bool
//
// where req is a Request object unique per action type.
// Each handler function must return a bool that indicates, whether the action was consumed.
// If an action is consumed, the action is not bubbled to the next middleware / store.
Base {
    id: root

    onDispatched: function(type, data) {
        // Check sync handlers first, since they are no network requests
        // that can be called without a deferred signal.
        // These handlers must call next and consumed themselves.
        if (SyncHandler.hasOwnProperty(type)) {
            SyncHandler[type](backend, root, type, data)
            return
        }

        // Cancel actions are special and always contain a callID that originated
        // from this middleware.
        if (type === "cancel") {
            // Cancel the request with the given call id.
            // If none such exists, this is a no-op.
            backend.cancelRequest(data.callID)
            consumed()
            return
        }

        if (backend.hasHandler(type)) {
            // Run the request and save the callID in the data.
            data.callID = backend.request(type, JSON.stringify(data))
            _requests[data.callID] = true
        }

        // Trigger next handler.
        next(type, data)
    }

    // init initializes this middleware.
    // Args:
    //  - window(ApplicationWindow) : The main application window.
    function init(window) {
        // Connect to the lostConnection signal.
        backend.lostConnection.connect(A.ALogin.lostConnection)

        // Connect to the requestUpdate signal.
        backend.requestUpdate.connect(function(type, callID, ret) {
            // Append the callID to the api data and emit the update signal.
            const data = ret !== undefined ? JSON.parse(ret) : {}
            data.callID = callID
            A.AInt.emitUpdate(type, data)
        })

        // Connect to the requestDone signal.
        backend.requestDone.connect(function(type, callID, ret, err) {
            // Request done, remove from active requests.
            delete _requests[callID]

            // Add the api data to the action data.
            const data = ret !== undefined ? JSON.parse(ret) : {}
            data.callID = callID
            data.api = {
                failed: !!err && ![L.Con.Err.Canceled, L.Con.Err.Closed].includes(err),
                canceled: err === L.Con.Err.Canceled
            }
            data.api.ok = !data.api.failed && !data.api.canceled

            // Emit a toast error for failed requests.
            if (data.api.failed) {
                if (L.Con.isKnownErr(err)) {
                    A.AAppToast.showError(L.Tr.err(err))
                } else {
                    A.AAppToast.showError(`${type}: ${err}`)
                }
            }

            // Emit the 'done' variant of this action.
            A.AInt.emitDone(type, data)
        })
    }

    //###############//
    //### Private ###//
    //###############//

    // Contains callIDs of active requests.
    property var _requests: ({})
}
