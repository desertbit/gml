.pragma library

.import Action as A
.import Lib as L


function view(state, data) {
    // WORKAROUND: Do not subscribe to the stats while a training is active.
    // nvidia-smi has a bug and we do not want to trigger it, since it will consume
    // so much RAM that nLine crashes during a training.
    if (!L.State.isTrain(state.nline.state)) {
        A.ADashboard.subscribeStats()
    }
    A.ANavigation.pushPage(L.Con.Page.Dashboard)
}

//################//
//### Internal ###//
//################//

function subscribeStats(state, data) {
    // Abort the current stream first.
    if (state.nline.stats.callID > 0) {
        A.AInt.emitCancel(state.nline.stats.callID)
    }

    state.nline.stats.callID = data.callID
}

function subscribeStatsUpdate(state, data) {
    // The temperature readings need to be handled specially.
    data.ts = Date.fromGo(data.ts)
    data.cpu.temps.forEach(temp => _addTempToStateTemps(state, temp, data.ts))
    data.gpus.forEach(gpu => _addTempToStateTemps(state, gpu.temp, data.ts))

    // Delete the data, as we added it to the store already.
    delete data.ts
    delete data.cpu.temps
    data.gpus.forEach(gpu => delete gpu.temp)

    // Copy the rest of the data.
    L.Obj.copyFrom(state.nline.stats, data)
}

//###############//
//### Private ###//
//###############//

function _addTempToStateTemps(state, temp, ts) {
    // Check, if a temp with the label already exists, and create it, if not.
    let t = state.nline.stats.temps.readings.find(t => t.label === temp.label)
    if (!t) {
        t = { label: temp.label, values: [] }
        state.nline.stats.temps.readings.push(t)
    }

    // Add the temp reading to it.
    // Ensure we remove old points, once we reached the maximum.
    t.values.push({ ts: ts, value: temp.degreeCelcius })
    if (t.values.length > state.nline.stats.temps.maxReadings) {
        t.values.splice(0, t.values.length - state.nline.stats.temps.maxReadings)
    }
}
