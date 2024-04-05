.pragma library

function setFilter(app, type, data) {
    app.settings.runActiveEventFilterCodes = data.eventCodes

    app.next(type, data)
}

//################//
//### Internal ###//
//################//
