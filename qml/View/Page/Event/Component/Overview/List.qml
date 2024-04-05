import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Store
import Theme

import View.Component.Event as VCE

Item {
    id: root

    // Number of items that fit in the content list.
    // Use the parents height so the calculation also works, if the item
    // is currently hidden.
    readonly property int numItems: Math.ceil(parent.height / (_.listDelegateHeight + list.spacing))

    // Emitted when the user taps on an event to view it.
    signal eventTapped(int id)

    QtObject {
        id: _

        // The height of a list delegate.
        readonly property real listDelegateHeight: 90
    }

    ColumnLayout {
        id: list

        anchors.fill: parent
        spacing: 0

        Repeater {
            id: repeater

            model: Store.state.eventOverview.list.page

            VCE.ListDelegate {
                inset: Theme.spacingM

                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.maximumHeight: _.listDelegateHeight
                Layout.alignment: Qt.AlignTop

                onTapped: id => root.eventTapped(id)
            }
        }

        // Pushes content to top, if not enough elements are available.
        Item { Layout.fillHeight: Store.state.eventOverview.list.page.length < root.numItems }
    }

    // No event available message.
    Text {
        anchors.centerIn: list
        font.pixelSize: Theme.fontSizeXL
        color: Theme.colorForegroundTier2
        text: "- " + qsTr("No event available") + " -"
        visible: Store.state.eventOverview.list.page.empty()
    }
}
