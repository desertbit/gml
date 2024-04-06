import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action as A
import Lib as L
import Store
import Theme

import View.Component.Button as VCB
import View.Component.Container as VCC
import View.Component.Form as VCF
import View.Component.Icon as VCI
import View.Component.Run as VCR

VCC.IconPane {
    id: root

    titleText: qsTr("Latest batches")
    titleIconName: "activity"
    titleIconColor: Theme.colorRun
    contentSpacing: 0
    titleRightContentSpacing: Theme.spacingXS
    titleRightContent: [
        Label {
            font.pixelSize: Theme.fontSizeM
            text: qsTr("Total: %L1").arg(Store.state.productDetail.numRuns)

            Layout.rightMargin: Theme.spacingXS
        },
        Button {
            text: qsTr("View all")
            verticalPadding: 0
            horizontalPadding: Theme.spacingS

            onClicked: A.ARunOverview.viewFromProductDetail(Store.state.productDetail.mid)
        }
    ]

    QtObject {
        id: _

        // The height of a list delegate.
        readonly property real listDelegateHeight: 70
        // Number of items that fit in the content list.
        readonly property int numItems: Math.floor(root.content.height / (listDelegateHeight + root.spacing))
        // The runs shown in this list.
        readonly property var runs: Store.view.productMaxRecentRuns(numItems)
    }

    Repeater {
        model: _.runs

        VCR.ListDelegate {
            inset: Theme.spacingM
            invertBackgroundColorOrder: true

            Layout.fillWidth: true
            Layout.preferredHeight: _.listDelegateHeight
            Layout.alignment: Qt.AlignTop

            onShowEvents: (productID, runID) => A.AEventOverview.viewFromProductDetail(productID, runID)
            onTapped: id => A.ARunDetail.viewFromProductDetail(id)
        }
    }

    // Pushes content to top, if not enough elements are available.
    Item { Layout.fillHeight: _.runs.length < _.numItems }

    // Shows a message if no run is available yet.
    Text {
        font.pixelSize: Theme.fontSizeXL
        color: Theme.colorForegroundTier2
        text: "- " + qsTr("No batch available") + " -"
        visible: _.runs.empty()
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter

        Layout.fillWidth: true
        Layout.fillHeight: true
    }
}
