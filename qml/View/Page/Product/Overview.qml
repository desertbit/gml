import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action.Product as AProduct
import Action.ProductDetail as AProductDetail
import Action.RunOverview as ARunOverview

import Store
import Theme

import View.Component.Button as VCB
import View.Component.Container as VCC
import View.Component.Form as VCF
import View.Component.Product as VCP

VCC.Page {
    id: root

    title: qsTr("Products")

    QtObject {
        id: _

        // The height of a list delegate.
        readonly property real listDelegateHeight: 130
        // Number of items that fit in the content list.
        readonly property int numItems: list.height > 0 ? Math.ceil(list.height / (listDelegateHeight + list.spacing)) : 0
        // The currently visible products after filtering.
        readonly property var products: Store.view.productsFilteredByName(bar.filterName)
    }

    VCP.ListHeaderBar {
        id: bar

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        itemsPerPage: _.numItems
        remainingItems: _.products.length
    }

    // Product list.
    ColumnLayout {
        id: list

        anchors {
            top: bar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        spacing: 2

        Repeater {
            id: repeater

            // Select the current page from the model.
            model: _.products.slice((bar.page - 1) * _.numItems, bar.page * _.numItems)

            VCP.ListDelegate {
                inset: Theme.spacingL

                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.maximumHeight: _.listDelegateHeight
                Layout.alignment: Qt.AlignTop

                onDeleted: id => AProduct.remove(id)
                onSelectedRuns: id => ARunOverview.viewFromProductOverview(id)
                onTapped: id => AProductDetail.view(id)
            }
        }

        // Pushes content to top, if not enough elements are available.
        Item { Layout.fillHeight: repeater.count < _.numItems }
    }

    // No product available helper message.
    Text {
        id: noProdAvail

        anchors.centerIn: parent
        font.pixelSize: Theme.fontSizeXL
        color: Theme.colorForegroundTier2
        text: "- " + qsTr("No product available") + " -"
        visible: Store.state.products.length === 0
    }
}
