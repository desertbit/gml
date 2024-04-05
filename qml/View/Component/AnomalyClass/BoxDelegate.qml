import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Lib as L
import Theme

Label {
    id: root

    required property var modelData  // Model.AnomalyClass
    required property int index

    property alias hoverEnabled: hover.enabled

    padding: 4
    color: root.modelData.textColor
    text: L.Tr.anomalyClass(root.modelData.id, root.modelData.name)
    font {
        pixelSize: Theme.fontSizeS
        weight: Font.DemiBold
    }

    background: Rectangle {
        color: hover.hovered ? Qt.lighter(root.modelData.color, 1.1) : root.modelData.color
        radius: root.padding
    }

    HoverHandler {
        id: hover

        enabled: false
    }
}
