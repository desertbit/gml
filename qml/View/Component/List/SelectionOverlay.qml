import QtQuick

import Theme

import View.Component.Icon as VCI

Rectangle {
    id: root

    property alias selected: iconBackground.visible

    color: "#77999999"

    Rectangle {
        id: iconBackground

        readonly property real padding: Theme.spacingXS

        anchors.centerIn: parent
        implicitWidth: icon.implicitWidth + (2*padding)
        implicitHeight: icon.implicitHeight + (2*padding)
        radius: 5
        color: Theme.colorAccent

        VCI.Icon {
            id: icon

            anchors.centerIn: parent
            name: "check"
            color: Theme.colorOnAccent
            size: Theme.iconSizeS
        }
    }
}
