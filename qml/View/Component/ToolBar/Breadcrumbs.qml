import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Theme

import View.Component.Handler as VCH
import View.Component.Icon as VCI

RowLayout {
    id: root

    property alias model: repeater.model
    property alias delegate: repeater.delegate

    // Emitted when the user clicks the back button.
    signal backPressed()

    spacing: 14

    Control {
        background: Rectangle {
            color: !enabled ? "#494949" : backHover.hovered ? "#f1f1f1" : "#595959"

            HoverHandler {
                id: backHover

                cursorShape: Qt.PointingHandCursor
            }

            VCH.Tap {
                onTapped: root.backPressed()
            }
        }

        padding: 8
        contentItem: VCI.Icon {
            name: "arrow-left"
            size: Theme.fontSizeXL
            font.weight: Font.DemiBold
            color: !enabled ? "grey" : backHover.hovered ? "black" : "white"
        }
        enabled: container.children.length > 2 // (repeater is included in length)
        implicitHeight: container.height // Make as tall as other breadcrumbs.
    }

    RowLayout {
        id: container

        spacing: 22

        Repeater {
            id: repeater
        }
    }
}
