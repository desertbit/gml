.pragma library

.import Action as A
.import Lib as L

function viewFromConnect(state, data) {
    if (state.app.opts.withAutoLogin) {
        A.ANavigation.pushPage(L.Con.Page.Status)
    } else {
        A.ANavigation.replacePage(L.Con.Page.Status)
    }
}

//--------------------------------------------

function setStreamType(state, data) {
    state.status.streamType = data.streamType

    // Restart the camera streams.
    A.ACamera.startStreams(data.streamType)
}

//################//
//### Internal ###//
//################//
