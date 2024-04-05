import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Theme

ColumnLayout {
    id: root

    // This content will be shown on the right side of the title bar in the state pane.
    property list<Item> titleRightContent

    spacing: Theme.spacingS
}