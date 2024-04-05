import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

import View.Component.Icon as VCI
import Theme

RoundButton {
    id: root

    property string toolTipText
    property alias fontIcon: contentIcon

    implicitHeight: implicitWidth
    contentItem: VCI.Icon {
        id: contentIcon

        // Same default value as original RoundButton.
        size: Theme.fontSizeXL
    }
    focusPolicy: Qt.TabFocus
    bottomInset: 0
    rightInset: 0
    topInset: 0
    leftInset: 0

    ToolTip.visible: toolTipText && hovered
    ToolTip.text: toolTipText
    ToolTip.delay: 1000

    Keys.onReturnPressed: clicked()
}
