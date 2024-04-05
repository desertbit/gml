.pragma library

.import View.Component.Container as VCC

function checkForUnsavedChanges(root, discardCb) {
    const item = root._stack.currentItem
    if (!(item instanceof VCC.Page) && !(item instanceof VCC.PageSelectionLayout)) {
        console.error(`current page ${item} is not a Page Component`)
        return
    }

    if (!item.hasUnsavedChanges) {
        discardCb()
        return
    }

    // Ask the user if he wants to discard his changes.
    root._unsavedChanges.discardCb = discardCb
    root._unsavedChanges.rejectCb = root.consumed
    root._unsavedChanges.open()
}
