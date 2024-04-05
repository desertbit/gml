import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

import Theme
import View.Component.Effect as VCE

Pane {
    id: root

    property int radius: 5

    property alias backgroundShadow: background

    padding: Theme.spacingS

    Material.elevation: 2

    background: VCE.BackgroundShadow { id: background }
}
