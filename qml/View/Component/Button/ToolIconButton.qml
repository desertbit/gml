import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl

import Theme
import View.Component.Icon as VCI

ToolButton {
    id: control

    property string toolTipText: ""
    property alias fontIcon: contentIcon
    property alias rippleColor: backgroundRipple.color

    // Replace with our Icon element.
    contentItem: VCI.Icon {
        id: contentIcon

        color: "white"
        size: Theme.fontSizeL
        verticalAlignment: Text.AlignVCenter
    }
    focusPolicy: Qt.TabFocus

    // Copied from https://github.com/qt/qtquickcontrols2/blob/dev/src/imports/controls/material/ToolButton.qml
    // Changed color.
    background: Ripple {
        id: backgroundRipple

        implicitWidth: control.Material.touchTarget
        implicitHeight: control.Material.touchTarget

        readonly property bool square: control.contentItem.width <= control.contentItem.height

        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        clip: !square
        width: square ? parent.height / 2 : parent.width
        height: square ? parent.height / 2 : parent.height
        pressed: control.pressed
        anchor: control
        active: control.enabled && (control.down || control.visualFocus || control.hovered)
        color: "#2AFFFFFF"
    }

    ToolTip {
        // Position the tool tip to the right, vertically centered.
        x: -width - Theme.spacingXXS
        y: (parent.height/2) - (height/2)
        text: control.toolTipText
        delay: 100
        visible: !!control.toolTipText && parent.hovered
        contentItem: Text {
            text: control.toolTipText
            color: "white"
        }
    }

    Keys.onReturnPressed: clicked()
}
