// zoom increases the content size by scale and positions it around center
// inside the flickable. This creates the effect of a zoom.
function zoom(step, center) {
    // Clip the scale to stay within our configured bounds.
    root.scale = Math.max(root.minScale, Math.min(root.maxScale, root.scale + step))

    // Zoom around the given center point.
    canvas.resizeContent(canvas.width * root.scale, canvas.height * root.scale, center)
    canvas.returnToBounds()
}

// zoomCenter is a variant of zoom that zooms around the content center of the canvas.
function zoomCenter(step) {
    zoom(step, Qt.point(canvas.width/2 + canvas.contentX, canvas.height/2 + canvas.contentY))
}

// Reset reverts all changes done to the flickable and its content.
function reset() {
    root.scale = 1
    canvas.contentX = 0
    canvas.contentY = 0
    canvas.contentWidth = canvas.width
    canvas.contentHeight = canvas.height
    canvas.returnToBounds()
}

// WheelHandler

const wheelStep = 0.2

function onWheel(event) {
    zoom(event.angleDelta.y > 0 ? wheelStep : -wheelStep, wheelHandler.point.position)
}

// PinchHandler

// Used to calculate the delta between the previous event and the current event.
var prevActiveScale = 0

function onActiveChanged(active) {
    // Disable the flickable during a pinch to prevent it messing with our event.
    // The flickable would try to set the position of the content item, which is
    // not possible during the pinch scaling.
    canvas.interactive = !active

    // Reset the previous active scale.
    prevActiveScale = 1
}

function onScaleChanged() {
    // Calculate delta and zoom in around the gesture's center position.
    zoom(pinchHandler.activeScale - prevActiveScale, pinchHandler.centroid.position)

    // Remember the last active scale.
    prevActiveScale = pinchHandler.activeScale
}
