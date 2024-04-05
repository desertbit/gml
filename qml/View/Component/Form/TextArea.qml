import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Theme

Flickable {
    id: root

    // TextArea
    // Can be used to set a fixed height for the text area.
    // Useful, if the height can or should not be determined by the outer layout.
    property alias textAreaHeight: root.height
    readonly property alias textArea: area
    property alias text: area.text
    property alias placeholderText: area.placeholderText

    leftMargin: Theme.spacingXXS
    rightMargin: Theme.spacingXXS

    Layout.fillWidth: true

    TextArea.flickable: TextArea {
        id: area

        font.pixelSize: Theme.fontSizeL
        selectByMouse: true
        wrapMode: TextArea.Wrap

        // Remove default Material input border
        background: Rectangle {
            anchors.fill: parent
            border {
                width: area.cursorVisible ? 2 : 1
                color: area.cursorVisible ? Material.accent : Material.color(Material.Grey, Material.Shade600)
            }
        }
    }

    ScrollBar.vertical: ScrollBar { }
}
