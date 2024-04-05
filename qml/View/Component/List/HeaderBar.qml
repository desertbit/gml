import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

import Theme

Pane {
    id: root

    z: 1 // For elevation.
    verticalPadding: Theme.spacingXS
    horizontalPadding: Theme.spacingS

    Material.elevation: 4
}
