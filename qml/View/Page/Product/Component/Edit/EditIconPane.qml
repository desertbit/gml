import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

import Theme

import View.Component.Container as VCC
import View.Component.Icon as VCI

VCC.IconPane {
    id: root

    required property bool valid

    contentSpacing: Theme.spacingM
    titleRightContent: VCI.Icon {
        id: invalidIcon

        name: "x-circle"
        color: Theme.error
        size: Theme.iconSizeS
        visible: false
    }

    states: [
        State {
            name: "invalid"
            when: !root.valid
            PropertyChanges { target: invalidIcon; visible: true }
        }
    ]
}
