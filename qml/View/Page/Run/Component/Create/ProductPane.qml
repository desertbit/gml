import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Lib as L
import Store
import Theme

import View.Component.Button as VCB
import View.Component.Container as VCC
import View.Component.Form as VCF
import View.Component.Image as VCI

VCC.TickIconPane {
    id: root

    required property Item pageRoot

    // Undefined, if productID === 0.
    readonly property var product: Store.state.products.find(p => p.id === root.productID)

    // The id of the currently selected product.
    // If no product is selected, the value is 0.
    property int productID: 0

    // Emitted when the user has selected a product.
    signal productSelected()

    titleText: "1. " + qsTr("Product selection")

    states: [
        State {
            name: "valid"
            extend: "ticked"
            when: root.product !== undefined
            PropertyChanges { target: thumbnail; background.visible: false; source: root.product.thumbnailSource }
            PropertyChanges { target: name; text: root.product.name }
            PropertyChanges { target: created; text: root.product.created.formatDateTime(Store.state.locale) }
            PropertyChanges { target: updated; text: root.product.updated.formatDateTime(Store.state.locale) }
            PropertyChanges { target: description; text: root.product.description || "---" }
            PropertyChanges { target: select; highlighted: false }
        }
    ]

    // Load the pre selected product, if set.
    Component.onCompleted: {
        if (Store.state.runCreate.preSelectedProductID > 0) {
            _.selectProduct(Store.state.runCreate.preSelectedProductID)
        }
    }

    QtObject {
        id: _

        function selectProduct(productID) {
            root.productID = productID
            root.productSelected()
            products.state = ""
        }
    }

    // The product selection.
    // Use all available space to show as many products as possible.
    ProductsPane {
        id: products

        y: parent.height
        parent: root.pageRoot
        width: parent.width
        height: parent.height * 0.85

        onSelected: id => _.selectProduct(id)
        onClose: state = ""

        states: [
            State {
                name: "open"
                PropertyChanges { target: products; y: parent.height - height }
            }
        ]

        Behavior on y { NumberAnimation { target: products; duration: 120; property: "y" } }
    }

    RowLayout {
        spacing: Theme.spacingS

        VCI.Image {
            id: thumbnail

            fillMode: Image.PreserveAspectFit
            altBackground: Theme.colorBackgroundTier2
            background.visible: true
            placeholder {
                anchors.margins: Theme.spacingM
                source: "qrc:/resources/icons/product.svg"
                sourceSize: Qt.size(150, 150)
                smooth: true
            }

            Layout.preferredWidth: 300
            Layout.preferredHeight: width / 1.75 // TODO: Can we fixate the aspect ratio?
        }

        ColumnLayout {
            spacing: Theme.spacingS

            VCF.LabeledColumnLayout {
                labelText: qsTr("Name")

                Text {
                    id: name

                    text: "---"
                    font.pixelSize: Theme.fontSizeL
                    maximumLineCount: 1
                    elide: Text.ElideRight

                    Layout.fillWidth: true
                }
            }

            VCF.LabeledColumnLayout {
                labelText: qsTr("Created")

                Text {
                    id: created

                    text: "---"
                    font.pixelSize: Theme.fontSizeL
                    maximumLineCount: 1
                    elide: Text.ElideRight

                    Layout.fillWidth: true
                }
            }

            VCF.LabeledColumnLayout {
                labelText: qsTr("Updated")

                Text {
                    id: updated

                    text: "---"
                    font.pixelSize: Theme.fontSizeL
                    maximumLineCount: 1
                    elide: Text.ElideRight

                    Layout.fillWidth: true
                }
            }
        }
    }

    RowLayout {
        spacing: Theme.spacingS

        VCF.LabeledColumnLayout {
            labelText: qsTr("Description")

            Text {
                id: description

                font.pixelSize: Theme.fontSizeL
                text: "---"
                wrapMode: Text.WordWrap
                elide: Text.ElideRight

                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }

        VCB.Button {
            id: select

            highlighted: true
            text: qsTr("Select")
            state: "medium"

            Layout.alignment: Qt.AlignBottom

            onClicked: products.state = "open"
        }
    }
}
