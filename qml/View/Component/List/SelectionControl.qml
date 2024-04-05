import QtQuick
import QtQuick.Layouts

import Theme

import View.Component.Button as VCB

RowLayout {
    id: root

    // The selector that this control belongs to.
    required property Selector selector
    // The text of the action that can be triggered with the selected items.
    required property string actionText

    // Emitted once the user clicks the action button.
    signal action()

    spacing: Theme.spacingS

    SelectionCancelButton {
        id: abort

        selector: root.selector
        height: button.height
        visible: selector.selectionMode
    }

    VCB.Button {
        id: button

        text: root.actionText
        highlighted: true

        onClicked: {
            if (root.selector.selectionMode) {
                root.action()
            } else {
                root.selector.startSelection()
            }
        }
    }
}
