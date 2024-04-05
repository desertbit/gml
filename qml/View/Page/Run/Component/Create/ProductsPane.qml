import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action.ProductDetail as AProductDetail

import Store
import Theme

import View.Component.Button as VCB
import View.Component.Container as VCC
import View.Component.Product as VCP

VCC.Pane {
    id: root

    // Emitted when the user has selected a product.
    signal selected(int id)
    // Emitted when the user has clicked the close button.
    signal close()

    QtObject {
        id: _

        // The maximum allowed height of a cell.
        readonly property real maxCellHeight: 100
        // Number of items that fit in the content list.
        readonly property int numItems: grid.height > 0 ? grid.columns * Math.ceil(grid.height / (maxCellHeight + grid.rowSpacing)) : 0
        // The currently visible products after filtering.
        readonly property var products: Store.view.productsFilteredByName(bar.filterName)
    }

    RowLayout {
        id: header

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        spacing: Theme.spacingM

        VCB.Button {
            text: qsTr("Close")
            state: "medium"
            flat: true
            highlighted: true

            onClicked: root.close()
        }

        VCP.ListHeaderBar {
            id: bar

            itemsPerPage: _.numItems
            remainingItems: _.products.length

            Layout.fillWidth: true
        }
    }

    // Product list.
    GridLayout {
        id: grid

        anchors {
            top: header.bottom
            topMargin: 2
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        columns: 3
        columnSpacing: 4
        rowSpacing: 2

        Repeater {
            id: repeater

            // Select the current page from the model.
            model: _.products.slice((bar.page - 1) * _.numItems, bar.page * _.numItems)

            VCP.ListDelegate {
                inset: Theme.spacingS
                selectMode: true

                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.maximumHeight: _.maxCellHeight
                Layout.alignment: Qt.AlignTop

                onInfo: id => AProductDetail.view(id)
                onTapped: id => root.selected(id)
            }
        }

        // Pushes content to top, if not enough elements are available.
        // Remove the repeater and the item itself from the calculation.
        Item { Layout.fillHeight: grid.children.length - 2 < _.numItems; Layout.columnSpan: 2 }
    }
}
