.pragma library

.import Action as A
.import Lib as L

.import "../conv.js" as Conv

function view(state, data) {
    A.AAnomalyClass.load()
    A.ANavigation.pushPage(L.Con.Page.AnomalyClassOverview)
}

//--------------------------------------------

function addOk(state, data) {
    // Convert the new class.
    Conv.anomalyClassFromGo(data.class)

    // Insert the class into our anomaly classes.
    // They are ordered by name in ascending order.
    state.anomalyClasses.splice(_insertionIndexForNameASCOrder(state, data.class.name), 0, data.class)
}

//--------------------------------------------

function editOk(state, data) {
    // Get the index at which the new class would have to be inserted to keep the order.
    const insertIdx = _insertionIndexForNameASCOrder(state, data.class.name)

    // Remove the locally selected color.
    delete state.anomalyClassOverview.selectedColors[data.class.id]

    // Update the class.
    const idx = state.anomalyClasses.findIndex(ac => ac.id === data.class.id)
    if (idx === -1) {
        return
    }

    state.anomalyClasses[idx] = data.class
    Conv.anomalyClassFromGo(data.class)

    // Move the class now to its final position, if needed.
    if (insertIdx !== idx) {
        const c = state.anomalyClasses[idx]
        state.anomalyClasses.splice(idx, 1)
        state.anomalyClasses.splice(insertIdx, 0, c)
    }
}

//--------------------------------------------

function removeOk(state, data) {
    // Remove all classes and local colors with the given ids.
    state.anomalyClasses = state.anomalyClasses.filter(ac => !data.ids.includes(ac.id))
    for (const id of data.ids) {
        delete state.anomalyClassOverview.selectedColors[id]
    }
}

//--------------------------------------------

function loadOk(state, data) {
    state.anomalyClasses = data.classes

    Conv.anomalyClassesFromGo(state.anomalyClasses)
}

//--------------------------------------------

function selectColorForClass(state, data) {
    state.anomalyClassOverview.selectedColors[data.id] = data.color
}

//--------------------------------------------

function deselectColorForClass(state, data) {
    delete state.anomalyClassOverview.selectedColors[data.id]
}

//--------------------------------------------

function selectRandomColorForClass(state, data) {
    state.anomalyClassOverview.selectedColors[data.id] = L.Color.random().toString()
}

//################//
//### Internal ###//
//################//

//##############//
//### Helper ###//
//##############//

// Returns the insertion index of the given name for the anomaly classes.
// Ret:
//  - index(int)
function _insertionIndexForNameASCOrder(state, name) {
    const idx = state.anomalyClasses.findIndex(ac => name.localeCompare(ac.name) <= 0)
    if (idx === -1) {
        return state.anomalyClasses.length
    }
    return idx
}
