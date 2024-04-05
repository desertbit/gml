import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

import Theme

RoundButton {
    id: root

    property color fontColor: Theme.colorForeground
    property color backgroundColor: "red"

    icon {
        width: Theme.iconSizeXL
        height: Theme.iconSizeXL
        color: root.fontColor
    }
    display: AbstractButton.TextBesideIcon
    font {
        pixelSize: Theme.fontSizeL
        weight: Font.DemiBold
        capitalization: Font.MixedCase
    }
    padding: 22
    radius: 5
    spacing: 18
    topInset: 0
    leftInset: 0
    rightInset: 0
    bottomInset: 0

    Material.foreground: root.fontColor
    Material.background: root.backgroundColor
    Material.elevation: 3
}
