.import QtQuick.Controls as QC

// Loads the given codes into the checkboxes.
// Args:
//  - codes(array)       : The event codes to select.
function loadCodesIntoCheckBoxes(codes) {
    forEachCheckbox(c => {
        if (codes.includes(c.code)) {
            if (!c.checked) {
                c.toggle()
            }
        } else if (c.checked) {
            c.toggle()
        }
    })
}

// Returns an array containing the event codes, whose checkbox is currently selected.
// Ret:
//  - Array of event codes.
function readCodesFromCheckBoxes() {
    let codes = []
    forEachCheckbox(c => {
        if (c.checked) {
            codes.push(c.code)
        }
    })
    return codes
}

// forEachCheckbox iterates over our popup's Checkboxes and calls f on each of them.
// The callback may abort the iteration early by returning true.
// Otherwise, it must return false.
// Args:
//  - popupContent(Item) : The QML Item containing the CheckBox instances.
//  - f           (func) : The callback to execute on each CheckBox
function forEachCheckbox(f) {
    // Iterate over the EventCodeBoxes.
    const children = popupContent.children
    for (let i = 0; i < children.length; ++i) {
        // Abort, if the callback returned true.
        if (children[i] instanceof QC.CheckBox && f(children[i])) {
            return
        }
    }
}
