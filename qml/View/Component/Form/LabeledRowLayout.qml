import QtQuick
import QtQuick.Layouts

import Theme

import "."

RowLayout {
    id: root

    property alias label: text
    property alias labelText: text.label
    property alias required: text.required

    spacing: Theme.spacingXS

    Label {
        id: text

        color: enabled ? Theme.colorForeground : Theme.colorForegroundTier3
    }
}
