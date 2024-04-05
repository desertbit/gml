import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

import View.Component.Icon as VCI
import Theme

Button {
    id: root

    property string toolTipText
    property alias fontIcon: contentIcon
    property alias contentSpacing: contentRow.spacing
    property alias label: contentText

    topInset: 0
    bottomInset: 0
    contentItem: Row{
        id: contentRow

        spacing: Theme.spacingXS

        VCI.Icon {
            id: contentIcon

            anchors.verticalCenter: parent.verticalCenter
            size: Theme.fontSizeXL
        }
        Text {
            id: contentText

            anchors.verticalCenter: parent.verticalCenter
            text: root.text
            font {
                pixelSize: Theme.fontSizeL
            }
            color: contentIcon.color
        }
    }
    focusPolicy: Qt.TabFocus

    ToolTip.visible: toolTipText && hovered
    ToolTip.text: toolTipText
    ToolTip.delay: 1000

    Keys.onReturnPressed: clicked()
}
