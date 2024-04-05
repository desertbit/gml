import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Theme

import View.Component.Handler as VCH

import "." // For Image Component

import "flickableImage.js" as Logic

Rectangle {
    id: root

    // Min and max scale values.
    readonly property real minScale: 1
    readonly property real maxScale: 5

    readonly property real imageX: ((canvas.contentWidth - canvasImg.paintedWidth) / 2) - canvas.contentX
    readonly property real imageY: ((canvas.contentHeight - canvasImg.paintedHeight) / 2) - canvas.contentY
    readonly property real imageWidth: canvasImg.paintedWidth
    readonly property real imageHeight: canvasImg.paintedHeight

    // The current scale of the content image.
    property real scale: 1
    // The source of the image.
    property alias source: canvasImg.source

    // Emits a signal when the user has tapped the image once.
    signal singleTapped()

    // Resets the flickable to the default state.
    function reset() { Logic.reset() }

    // Zooms in/out around center by the given positive/negative step.
    function zoom(step, center) { Logic.zoom(step, center) }

    function zoomCenter(step) { Logic.zoomCenter(step) }

    color: "black"

    Flickable {
        id: canvas

        anchors.fill: parent
        contentWidth: width
        contentHeight: height
        boundsBehavior: Flickable.DragOverBounds

        Image {
            id: canvasImg

            fillMode: Image.PreserveAspectFit
            mipmap: true
            smooth: true
            width: canvas.contentWidth
            height: canvas.contentHeight
        }

        VCH.Tap {
            onSingleTapped: root.singleTapped()
        }

        WheelHandler {
            id: wheelHandler

            acceptedModifiers: Qt.ControlModifier
            target: null
            // Prevents the flickable from taking over the scrolling.
            grabPermissions: PointerHandler.TakeOverForbidden

            onWheel: event => Logic.onWheel(event)
        }

        PinchHandler {
            id: pinchHandler

            target: null
            minimumPointCount: 2
            maximumPointCount: 2

            onActiveChanged: Logic.onActiveChanged(active)
            onScaleChanged: Logic.onScaleChanged()
        }
    }
}
