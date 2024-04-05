import QtQuick

import View.Component.Button as VCB

import Theme

VCB.IconButton {
    id: selectionAbort

    required property Selector selector

    fontIcon {
        name: "x"
        color: "white"
        font {
            pixelSize: Theme.fontSizeM
            weight: Font.DemiBold
        }
    }
    label.font.pixelSize: Theme.fontSizeM
    text: `${selector.numSelected}`
    highlighted: true
    verticalPadding: Theme.spacingXS
    horizontalPadding: Theme.spacingXS

    onClicked: selector.deselectAll()
}
