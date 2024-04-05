.pragma library

.import Lib as L

function anomalyClassesFromGo(acs) {
    acs.forEach(ac => anomalyClassFromGo(ac))
}

function anomalyClassFromGo(ac) {
    const qColor = L.Color.jsRGBToQMLColor(ac.color)
    ac.created = Date.fromGo(ac.created)
    ac.color = qColor.toString()
    ac.textColor = L.Color.foregroundOfColor(qColor)
}

//--------------------------------------------

function customTrainImagesFromGo(ctis) {
    ctis.forEach(cti => customTrainImageFromGo(cti))
}

function customTrainImageFromGo(cti) {
    cti.created = Date.fromGo(cti.created)
}

//--------------------------------------------

function eventsFromGo(evs) {
    evs.forEach(ev => eventFromGo(ev))
}

function eventFromGo(e) {
    e.ts = Date.fromGo(e.ts)
}

//--------------------------------------------

function aggrEventsFromGo(es) {
    es.forEach(e => aggrEventFromGo(e))
}

function aggrEventFromGo(e) {
    e.ts = Date.fromGo(e.ts)
}

//--------------------------------------------

function aggrMeasurePointsFromGo(ps) {
    ps.forEach(p => aggrMeasurePointFromGo(p))
}

function aggrMeasurePointFromGo(p) {
    p.ts = Date.fromGo(p.ts)
}

//--------------------------------------------

function productFromGo(p) {
    p.created = Date.fromGo(p.created)
    p.updated = Date.fromGo(p.updated)
    p.lastTrained = Date.fromGo(p.lastTrained)
}

function productDetailFromGo(p) {
    productFromGo(p)
    p.recentRuns.forEach(r => runFromGo(r))
}

//--------------------------------------------

function runsFromGo(rs) {
    rs.forEach(r => runFromGo(r))
}

function runFromGo(r) {
    r.created = Date.fromGo(r.created)
    r.finished = Date.fromGo(r.finished)
}

function runPausesFromGo(ps) {
    ps.forEach(p => runPauseFromGo(p))
}

function runPauseFromGo(p) {
    p.paused = Date.fromGo(p.paused)
    p.resumed = Date.fromGo(p.resumed)
}
