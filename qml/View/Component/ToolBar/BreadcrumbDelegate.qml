import QtQuick
import QtQuick.Controls

import Theme

import View.Component.Handler as VCH

Control {
    id: root

    required property int index
    required property bool highlighted

    // The text shown in the breadcrumb.
    property alias text: text.text

    // True if this is the first item.
    readonly property bool first: index === 0

    // Emitted, if the user clicks on this control.
    signal selected()

    rightInset: -(_.arrowLength)
    leftInset: (first ? 0.5 : 1) * -(_.arrowLength)
    verticalPadding: 8
    horizontalPadding: 10

    contentItem: Text {
        id: text

        font {
            pixelSize: Theme.fontSizeM
            weight: Font.DemiBold
        }
        color: root.highlighted || hover.hovered ? "black" : "white"
    }

    background: Canvas {
        onPaint: {
            // Retrieve a Context2D.
            let ctx = getContext("2d")

            // Choose background color.
            ctx.fillStyle = root.highlighted || hover.hovered ? "#f1f1f1" : "#595959"

            // Draw the path.
            ctx.beginPath()
            ctx.moveTo(0, 0)
            // Right male arrow.
            ctx.lineTo(width - Math.abs(root.rightInset), 0)
            ctx.lineTo(width, height/2)
            ctx.lineTo(width - Math.abs(root.rightInset), height)
            // Left female arrow (or straight segment, if first).
            ctx.lineTo(0, height)
            if (!root.first) {
                ctx.lineTo(Math.abs(root.leftInset), height/2)
            }
            ctx.lineTo(0, 0)

            // Fill path with color.
            ctx.fill()
        }

        HoverHandler {
            id: hover

            cursorShape: Qt.PointingHandCursor

            onHoveredChanged: parent.requestPaint()
        }

        VCH.Tap {
            onTapped: root.selected()
        }
    }

    QtObject {
        id: _

        readonly property int arrowLength: 15
    }
}
