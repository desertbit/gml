import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Theme

import View.Component.Icon as VCI

// A row layout with an info icon and an italic text.
// Meant for informational messages.
RowLayout {
    id: root

    property alias text: label.text

    spacing: Theme.spacingS

    VCI.Icon {
        name: "info"
        size: Theme.iconSizeXS
        color: enabled ? Material.color(Material.Blue) : Material.color(Material.Grey, Material.Shade400)
    }

    Text {
        id: label

        font.italic: true
        wrapMode: Text.WordWrap
        color: enabled ? Theme.colorForegroundTier3 : Theme.colorForeground

        Layout.fillWidth: true
    }
}
