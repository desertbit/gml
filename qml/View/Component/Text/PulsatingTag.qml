import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Theme

// Shows a text with a loading animation inside of a colored tag background.
// If visible is true, the tag fades in and out continuously.
Rectangle {
    id: root

    property real padding: Theme.spacingS
    // The text being displayed.
    property alias text: label.text

    implicitWidth: content.implicitWidth+2*padding
    implicitHeight: content.implicitHeight+2*padding
    color: Theme.transparentBlack
    radius: 10

    // An animation to fade the tag in and out continuously.
    SequentialAnimation {
        running: root.visible
        loops: Animation.Infinite

        OpacityAnimator {
            id: opacityAnim

            target: root
            from: 0.3
            to: 1
            duration: 1000
        }
        OpacityAnimator {
            target: opacityAnim.target
            from: opacityAnim.to
            to: opacityAnim.from
            duration: opacityAnim.duration
        }
    }

    Row {
        id: content

        anchors.centerIn: parent
        spacing: Theme.spacingXS

        BusyIndicator {
            anchors.verticalCenter: parent.verticalCenter
            running: true
            height: label.height*1.5

            Material.accent: "white"
        }

        Text {
            id: label

            anchors.verticalCenter: parent.verticalCenter
            font {
                pixelSize: Theme.fontSizeL
                weight: Font.DemiBold
                italic: true
            }
            color: "white"
        }
    }
}