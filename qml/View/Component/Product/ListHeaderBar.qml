import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action.Product as AProduct

import Lib as L
import Store
import Theme

import View.Component.Button as VCB
import View.Component.Form as VCF
import View.Component.List as VCL

VCL.HeaderBar {
    id: root

    required property int itemsPerPage
    required property int remainingItems

    readonly property alias filterName: name.text
    readonly property alias page: pageCtrl.page

    RowLayout {
        anchors.fill: parent
        spacing: Theme.spacingS

        VCF.LabeledColumnLayout {
            label {
                text: qsTr("Name")
                font.pixelSize: Theme.fontSizeS
            }

            VCF.TextField {
                id: name

                placeholderText: qsTr("Filter name") + "..."

                Layout.minimumWidth: 206
                Layout.bottomMargin: Theme.spacingXS
            }
        }

        VCB.Button {
            text: qsTr("Reset filter")
            enabled: name.text !== ""

            onClicked: name.text = ""
        }

        Item { Layout.fillWidth: true }

        // Page selection.
        VCL.PaginationControl {
            id: pageCtrl

            totalPages: Math.ceil(remainingElements / root.itemsPerPage)
            totalElements: Store.state.products.length
            remainingElements: root.remainingItems
        }

        /*VCB.RefreshButton {
            flat: true

            onTriggered: AProduct.loadProducts()
        }*/
    }
}
