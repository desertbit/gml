.pragma library

.import Action as A
.import Lib as L

.import "../initState.js" as IS

//################//
//### Internal ###//
//################//

function subscribeUpdate(state, data) {
    // If the new state is any run state and the current one not, request the currently active run.
    if (!L.State.isRun(state.nline.state) && L.State.isRun(data.state)) {
        A.ARunActive.load().then(() => {
            // Unsubscribe not needed, state change away from State.Run will automatically close streams.
            A.ARunActive.subscribeEvents(state.runActive.product.id, state.runActive.filter.eventCodes, state.runActive.events.max)
            A.ARunActive.subscribeAggrEvents(state.runActive.filter.timeRange, state.runActive.filter.timeInterval, state.runActive.filter.eventCodes)
            A.ARunActive.subscribeEventDistribution(state.runActive.filter.timeRange, state.runActive.filter.eventCodes)
        })
    }

    // Show a success toast message once the training has succeeded.
    if (data.state === L.State.TrainProductDone) {
        A.AAppToast.showSuccess(qsTr("Product %1 successfully created").arg(state.nline.stateTrain.name))
    }

    // Display the state error popup, when we are not on the Status page,
    // as it already displays the error itself.
    if (data.state === L.State.Error && state.app.pages[0] !== L.Con.Page.Status) {
        A.AState.showErrorPopup()
    }

    // If the new state is the run state, subscribe to its updates.
    // Set the stream type on the status page to the defect stream.
    if (state.nline.state !== L.State.Run && data.state === L.State.Run) {
        A.ARunActive.subscribeStats()
        A.AStatus.setStreamType(L.Con.StreamType.Defects)
    }

    // Unsubscribe from the run updates, if the new state is no longer the run state.
    if (state.nline.state === L.State.Run && data.state !== L.State.Run) {
        A.ARunActive.unsubscribeStats(state.runActive.stats.callID)
    }

    // Reset the run state, if the new state is not a run state anymore.
    if (L.State.isRun(state.nline.state) && !L.State.isRun(data.state)) {
        const runActiveStreamTypes = [L.Con.StreamType.Defects, L.Con.StreamType.DefectBoxes]
        if (runActiveStreamTypes.includes(state.status.streamType)) {
            A.AStatus.setStreamType(L.Con.StreamType.Raw)
        }
        if (runActiveStreamTypes.includes(state.cameraDetail.streamType)) {
            A.ACameraDetail.setStreamType(L.Con.StreamType.Raw)
        }

        // Reset the active run state.
        L.Obj.copyFrom(state.runActive, IS.InitState.runActive)
    }

    // If the previous state was a classifyRun state which successfully finished,
    // we need to reload all runs that have been affected by this.
    if (state.nline.state === L.State.ClassifyRun && data.state === L.State.Ready) {
        if (state.runDetail.productID === state.nline.stateClassify.productID) {
            A.ARunDetail.load(state.runDetail.id)
        }
        if (state.runRecent.productID === state.nline.stateClassify.productID) {
            A.ARunRecentDetail.load(state.runRecent.id)
        }
    }

    A.AAnomalyClass.load()

    state.nline.state = data.state
    state.nline.stateProgress = data.progress
    L.Obj.copyFrom(state.nline.stateRun, data.run)
    L.Obj.copyFrom(state.nline.stateTrain, data.train)
    L.Obj.copyFrom(state.nline.stateErr, data.err)
    L.Obj.copyFrom(state.nline.stateClassify, data.classifyRun)
}
