import QtQuick.Controls
import QtQuick.Controls.Material

import Theme
import View.Component.Effect as VCE

Label {
    id: root

    property int radius: 4

    padding: Theme.spacingS

    Material.elevation: 2

    background: VCE.BackgroundShadow {}
}
