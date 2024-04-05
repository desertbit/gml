import QtQuick

import Theme

import View.Component.Icon as VCI

Row {
    property alias icon: icon
    property alias label: text

    spacing: Theme.spacingXS

    states: [
        State {
            name: "inactive"
            PropertyChanges { target: icon; name: "x-circle"; color: Theme.error }
            PropertyChanges { target: text; text: qsTr("No") }
        }
    ]

    VCI.Icon {
        id: icon

        anchors.verticalCenter: parent.verticalCenter
        name: "check-circle"
        color: Theme.success
        size: Theme.iconSizeM
    }

    Text {
        id: text

        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: Theme.fontSizeM
        text: qsTr("Yes")
    }
}
