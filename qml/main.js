/**
 * nLine
 * 
 * Copyright (c) 2023 Wahtari GmbH
 * All rights reserved
 */

function handleInputPanelViewport() {
    if (!input.enabled) {
        return
    }

    if (Qt.inputMethod.visible) {
        moveActiveFocusItemIntoViewPort()
    } else {
        // Simply reset the viewport.
        stack.y = 0
    }
}

function moveActiveFocusItemIntoViewPort() {
    const item = root.activeFocusItem
    if (!item || !Qt.inputMethod.visible || input.height === 0) {
        return
    }

    // Search upwards of the control and see, if stack is one of its ancestors.
    let parent = item.parent
    while (parent && parent !== stack) {
        // Continue search upwards.
        parent = parent.parent
    }
    if (!parent) {
        return
    }

    // Convert the position of the item to the stack's coordinate space.
    const point = item.mapToItem(stack, item.x, item.y)

    // Calculate the available space between keyboard and stack.
    const space = stack.height - input.height

    // Position the view in the center of this space.
    // If the view is too big (say a large TextArea for example), we
    // position the view at the top with some padding.
    let yPos = 0
    if (item.height < space) {
        yPos = point.y - (space / 2) + (item.height / 2)
    } else {
        yPos = point.y - 8
    }
    // Do not allow values less than 0.
    yPos = Math.max(0, yPos)

    // Set the stack's vertical position.
    stack.y = -yPos
}