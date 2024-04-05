import QtQuick

QtObject {
    id: root

    // Whether we are currently in selection mode.
    readonly property bool selectionMode: _selectionMode

    // The number of selected items.
    readonly property int numSelected: _numSelected

    // Sets the selector into selection mode.
    // Called implicitly, when selectItem or deselectItem are called.
    function startSelection() {
        _selectionMode = true
    }

    // Sets the selector into non selection mode.
    // Called implicitly, when deselectAll is called.
    function stopSelection() {
        _selectionMode = false
    }

    // selected returns true, if the given id is selected.
    // The second argument 'numSelected' is unused, but very important.
    // It must always be given as 'selector.numSelected' to trigger a property binding
    // update when the selection changes. Otherwise, the controls won't update themselves.
    // Args:
    //  id(any)          : The id to select.
    //  numSelected(int) : The number of currently selected items (to trigger property binding)
    function selected(id, numSelected) {
        return _selected.has(id)
    }

    // select adds the given ids to the selection.
    // If an id is already selected, this is a no-op for that id.
    // Args:
    //  ids(int,variadic) : The ids to select.
    function select(...ids) {
        for (const id of ids) {
            if (_selected.has(id)) {
                continue
            }

            _selected.set(id, true)
            _numSelected++
        }
        startSelection()
    }

    // deselect removes the the given id from the selection.
    // If the id is not selected, this is a no-op.
    // Args:
    //  id(any) : The id to deselect.
    function deselect(id) {
        if (!_selected.delete(id)) {
            return
        }

        _numSelected--
        startSelection()
    }

    // deselectAll clears the current selection.
    // Also ends the selection mode.
    function deselectAll() {
        _selected.clear()
        _numSelected = 0
        stopSelection()
    }

    // selectedIDs returns a javascript array containing the selected ids.
    // Ret:
    //  array
    function selectedIDs() {
        return Array.from(_selected.keys())
    }

    //###############//
    //### Private ###//
    //###############//

    // Map of ids that are currently selected.
    readonly property var _selected: new Map()

    // True, if the selector is currently in selection mode.
    property bool _selectionMode: false

    // The currently selected number of items.
    property int _numSelected: 0
}
