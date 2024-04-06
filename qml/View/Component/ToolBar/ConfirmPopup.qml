import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects // For DropShadow

import Theme
import View.Component.Button as VCB

Popup {
    id: root

    property alias text: message.text

    // Emitted once the popup has been confirmed.
    signal confirmed()

    y: parent.height
    x: -width + parent.width
    leftPadding: Theme.spacingS
    rightPadding: Theme.spacingS
    topPadding: 0
    bottomPadding: 0

    background: Rectangle {
        color: "white"
        layer.enabled: true
        layer.effect: DropShadow {
            cached: true
            radius: 5
            samples: 7
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 2
        }
    }

    RowLayout {
        spacing: Theme.spacingXXS

        Text {
            id: message

            font {
                pixelSize: Theme.fontSizeL
            }

            Layout.rightMargin: Theme.spacingXXS
        }

        VCB.IconButton {
            flat: true
            padding: Theme.spacingM
            fontIcon {
                name: "x"
                size: Theme.fontSizeL
                color: Theme.error
            }

            Layout.preferredWidth: height

            onClicked: root.close()
        }
        VCB.IconButton {
            flat: true
            padding: Theme.spacingM
            fontIcon {
                name: "check"
                size: Theme.fontSizeL
            }

            Layout.preferredWidth: height

            onClicked: {
                root.confirmed()
                root.close()
            }
        }
    }
}
