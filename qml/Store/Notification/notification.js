.pragma library

.import Lib as L

function markRead(state, data) {
    state.notifications.unread = 0
}

//################//
//### Internal ###//
//################//

function addProgress(state, data) {
    state.notifications.unread++
    state.notifications.items.push({
        type: data.type,
        callID: data.callID,
        data: { progress: 0 }
    })
}

//--------------------------------------------

function updateProgress(state, data) {
    const item = state.notifications.items.find(n => n.callID === data.callID)
    if (item) {
        item.data.progress = data.progress
    }
}

//--------------------------------------------

function removeProgress(state, data) {
    state.notifications.unread = Math.max(0, state.notifications.unread - 1)
    const idx = state.notifications.items.findIndex(n => n.callID === data.callID)
    if (idx !== -1) {
        state.notifications.items.splice(idx, 1)
    }
}

//--------------------------------------------

function addUpdateAvailable(state, data) {
    state.notifications.unread++
    state.notifications.items.push({
        type: L.Con.Notification.UpdateAvailable
    })
}
