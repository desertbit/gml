import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action.EventDetail as AEventDetail
import Action.EventOverview as AEventOverview

import Lib as L
import Store
import Store.Model as SM
import Theme

import View.Component.Button as VCB
import View.Component.Container as VCC
import View.Component.Event as VCE
import View.Component.Form as VCF

VCC.IconPane {
    id: root

    required property SM.RunDetail model

    titleText: qsTr("Latest events")
    titleIconName: "activity"
    titleIconColor: Material.color(Material.Indigo)
    titleRightContentSpacing: Theme.spacingXS
    contentSpacing: 0
    titleRightContent: [
        Label {
            font.pixelSize: Theme.fontSizeM
            text: qsTr("Total: %L1").arg(root.model.numEvents)

            Layout.rightMargin: Theme.spacingXS
        },
        VCB.Button {
            text: qsTr("View all")

            onClicked: AEventOverview.viewFromRunDetail(root.model.productID, root.model.id, L.Con.EventOverviewState.List)
        }
    ]

    QtObject {
        id: _

        // The maximum allowed height of a cell.
        readonly property real listDelegateHeight: 80
        // Number of items that fit in the content list.
        readonly property int numItems: Math.floor(root.content.height / (listDelegateHeight + root.spacing))
        // The events shown in this list.
        readonly property var events: root.model.latestEvents.slice(0, numItems)
    }

    Repeater {
        model: _.events

        VCE.ListDelegate {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignTop

            onTapped: id => AEventDetail.viewFromRunDetail(id, root.model.id, root.model.productID)
        }
    }

    // Pushes content to top, if not enough elements are available.
    Item { Layout.fillHeight: root.model.latestEvents.length < _.numItems }

    // Shows a message if not one event is available.
    Text {
        font.pixelSize: Theme.fontSizeXL
        color: Theme.colorForegroundTier2
        text: "- " + qsTr("No events available") + " -"
        visible: _.events.empty()
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter

        Layout.fillWidth: true
        Layout.fillHeight: true
    }
}
