import QtQuick as Q

import "."

Q.Text {
    id: root

    property string name
    property alias size: root.font.pixelSize

    horizontalAlignment: Q.Text.AlignHCenter
    verticalAlignment: Q.Text.AlignVCenter
    font {
        family: Font.font.name
        weight: Q.Font.Light
    }
    text: !!name ? Font.mapping[name] : ""
}
