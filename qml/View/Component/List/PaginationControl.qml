import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Theme

import View.Component.Button as VCB

// Page selection.
RowLayout {
    id: root

    // The total number of pages that are available.
    required property int totalPages
    // The total number of elements that are available.
    // -1 to hide this label.
    required property int totalElements
    // The total number of elements that remain after filter were applied.
    // -1 to hide this label.
    required property int remainingElements

    // The current page being shown.
    property int page: 1
    // If true, the arrow buttons + page number are hidden.
    property bool hideControls: false

    // Emmitted when the user clicked on the next button.
    signal next()
    // Emmitted when the user clicked on the previous button.
    signal prev()

    // Jump adds count to the current page.
    // Makes sure that page stays within its bounds.
    function jump(count) {
        page = Math.max(1, Math.min(page + count, totalPages))
    }

    spacing: Theme.spacingS

    VCB.RoundIconButton {
        enabled: root.page > 1
        highlighted: true
        fontIcon {
            color: Theme.colorOnAccent
            name: "arrow-left"
        }
        visible: !root.hideControls

        onClicked: {
            root.page--
            root.prev()
        }
    }

    Text {
        text: `${root.page}/${root.totalPages}`
        font {
            pixelSize: Theme.fontSizeL
        }
        visible: !root.hideControls
    }

    VCB.RoundIconButton {
        enabled: root.page < root.totalPages
        highlighted: true
        fontIcon {
            color: Theme.colorOnAccent
            name: "arrow-right"
        }
        visible: !root.hideControls

        onClicked: {
            root.page++
            root.next()
        }
    }

    ColumnLayout {
        spacing: 2

        Layout.alignment: Qt.AlignVCenter

        Text {
            text: qsTr("Total: %L1").arg(root.totalElements)
            font.pixelSize: Theme.fontSizeM
            visible: root.totalElements >= 0
        }
        Text {
            text: qsTr("Remaining: %L1").arg(root.remainingElements)
            font.pixelSize: Theme.fontSizeM
            visible: root.remainingElements >= 0
        }
    }
}
