/**
 * nLine
 * 
 * Copyright (c) 2023 Wahtari GmbH
 * All rights reserved
 */

.pragma library

// Searches the whole state for the events with the given ids and executes
// the given callback on all found instances of them.
// Args:
//  - state(object) : The current state
//  - ids(array)    : The ids of the events
//  - cb(function)  : The callback to execute on each event, receives the
//                    event as single argument
function modifyEventsByIDs(state, ids, cb) {
    // Modify the events in the whole store.
    let instances = [].concat(
        state.eventDetail,
        state.eventOverview.list.page,
        state.runActive.events.model,
        state.runDetail.latestEvents,
        state.runRecent.latestEvents
    )
    for (const ev of instances) {
        if (ev && ids.includes(ev.id)) {
            cb(ev)
        }
    }
}
