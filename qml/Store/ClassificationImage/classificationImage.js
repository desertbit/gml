/**
 * nLine
 * 
 * Copyright (c) 2023 Wahtari GmbH
 * All rights reserved
 */

.pragma library

.import Action as A
.import Lib as L

.import "../util.js" as Util

function removeOk(state, data) {
    // For every image that was removed, saved its associated eventID, 
    // so we can reset the flags on them, if the event still exists.
    const eventIDs = state.classificationImageOverview.images
                        .filter(img => data.imageIDs.includes(img.id) && img.eventID > 0)
                        .map(img => img.eventID)

    if (state.classificationImageDetail.eventID > 0) {
        eventIDs.push(state.classificationImageDetail.eventID)
    }

    // Modify all found events and remove the used flag.
    Util.modifyEventsByIDs(state, eventIDs, ev => ev.usedAsCustomTrainImage = false)

    // Remove from overview state.
    state.classificationImageOverview.images = state.classificationImageOverview.images.filter(img => !data.imageIDs.includes(img.id))

    // If the image is currently being displayed in the detail,
    // go back from this page.
    if (data.imageIDs.includes(state.classificationImageDetail.id) && state.app.pages[0] === L.Con.Page.ClassificationImageDetail) {
        A.ANavigation.popPage()
    }
}
