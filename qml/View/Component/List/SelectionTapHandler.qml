import QtQuick

import View.Component.Handler as VCH

// This tap handler can be used together with the Selector type.
// It will emit a selected/deselected signal, if the selection mode is already active and the item is tapped.
// Otherwise, a standard tapped signal is emitted.
// A long press also triggers a selected signal, if the selection mode was not yet active.
Item {
    id: root

    // Must be true, if the selection mode is active.
    required property bool selectionMode
    // Must be true, if the item is currently selected.
    required property bool isSelected
    // If false, no selected or deselected signals are emitted.
    property bool canSelect: true

    // Emitted when the item has been selected.
    signal selected()
    // Emitted when the item has been deselected.
    signal deselected()
    // Emitted when the item has been tapped.
    signal tapped()

    anchors.fill: parent

    VCH.Tap {
        onTapped: {
            if (root.selectionMode && root.canSelect) {
                if (root.isSelected) {
                    root.deselected()
                } else {
                    root.selected()
                }
            } else {
                root.tapped()
            }
        }
        onLongPressed: {
            if (!root.selectionMode && root.canSelect) {
                root.selected()
            }
        }
    }
}