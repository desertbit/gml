import QtQuick
import QtQuick.Layouts

import Theme

import "."

ColumnLayout {
    id: root

    property alias label: text
    property alias labelText: text.label
    property alias required: text.required

    Label {
        id: text

        color: enabled ? Theme.colorForeground : Theme.colorForegroundTier3
    }
}
