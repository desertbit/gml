.pragma library

.import Dispatcher as D

// View the anomaly class overview page.
function view() {
    D.Dispatcher.dispatch(_type(view.name), {})
}

// Adds a new anomaly class with the given name.
// Args:
//  - name(string)    : The new name of the class
//  - jsColor(object) : The associated color of the class
function add(name, jsColor) {
    D.Dispatcher.dispatch(_type(add.name), {
        name: name,
        color: jsColor
    })
}

// Edits the anomaly class with the given id and updates its name.
// Args:
//  - id(int)         : The id of the anomaly class
//  - name(string)    : The new name of the anomaly class
//  - jsColor(object) : The associated color of the class
function edit(id, name, jsColor) {
    D.Dispatcher.dispatch(_type(edit.name), {
        id: id,
        name: name,
        color: jsColor
    })
}

// Deletes the anomaly classes with the given ids.
// Args:
//  - ids(array) : The ids of the anomaly classes
// Ret:
//  - dispatch promise
function remove(ids) {
    return D.Dispatcher.dispatch(_type(remove.name), { ids: ids }, true)
}

// Loads all anomaly classes at once.
function load() {
    D.Dispatcher.dispatch(_type(load.name), {})
}

// Selects a local color for the class with the given id.
// Args:
//  - id(int) : The id of the anomaly class
function selectColorForClass(id) {
    D.Dispatcher.dispatch(_type(selectColorForClass.name), { id: id })
}

// Deselects the local color for the class with the given id.
// Args:
//  - id(int) : The id of the anomaly class
function deselectColorForClass(id) {
    D.Dispatcher.dispatch(_type(deselectColorForClass.name), { id: id })
}

// Selects a random local color for the class with the given id.
// Args:
//  - id(int) : The id of the anomaly class
function selectRandomColorForClass(id) {
    D.Dispatcher.dispatch(_type(selectRandomColorForClass.name), { id : id })
}

//################//
//### Internal ###//
//################//

//###############//
//### Private ###//
//###############//

// Returns the action type for the given function name of this script.
// Ret:
//  - string
function _type(funcName) {
    return "anomalyClass" + funcName.capitalize()
}
