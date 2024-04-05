.import QtQuick.Controls as QC

// Loads the given class ids into the checkboxes.
// Args:
//  - classIDs(array) : The class ids to select.
function loadClassIDsIntoCheckBoxes(classIDs) {
    forEachCheckbox(c => {
        if (classIDs.includes(c.classID)) {
            if (!c.checked) {
                c.toggle()
            }
        } else if (c.checked) {
            c.toggle()
        }
    })
}

// Returns an array containing the classIDs, whose checkbox is currently selected.
// Ret:
//  - Array of classIDs.
function readClassIDsFromCheckBoxes() {
    const classIDs = []
    forEachCheckbox(c => {
        if (c.checked) {
            classIDs.push(c.classID)
        }
    })
    return classIDs
}

// forEachCheckbox iterates over our popup's Checkboxes and calls f on each of them.
// The callback may abort the iteration early by returning true.
// Otherwise, it must return false.
function forEachCheckbox(f) {
    // Iterate over the Checkboxes.
    const children = checkboxGrid.children
    for (let i = 0; i < children.length; ++i) {
        // Abort, if the callback returned true.
        if (children[i] instanceof QC.CheckBox && f(children[i])) {
            return
        }
    }
}
