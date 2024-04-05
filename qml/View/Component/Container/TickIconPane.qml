import QtQuick

import Theme

import View.Component.Icon as VCI

IconPane {
    id: root

    title.font.pixelSize: Theme.fontSizeL
    contentSpacing: Theme.spacingS
    titleRightContent: VCI.Icon {
        id: icon

        name: "square"
        size: Theme.iconSizeM
    }

    states: [
        State {
            name: "disabled"
            when: !enabled
            PropertyChanges { target: root; title.color: Theme.colorForegroundTier3 }
            PropertyChanges { target: icon; color: Theme.colorForegroundTier3 }
        },
        State {
            name: "ticked"
            PropertyChanges { target: icon; name: "check-square"; color: Theme.success }
        }
    ]
}
