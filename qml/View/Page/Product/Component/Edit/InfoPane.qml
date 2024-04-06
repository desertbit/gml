import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import Action as A
import Lib as L
import Store
import Theme

import View.Component.Form as VCF
import View.Component.Image as VCImg

EditIconPane {
    id: root

    property alias name: name.text
    property alias description: description.text

    valid: !nameErr.visible
    titleText: qsTr("Info")
    titleIconName: "info"
    titleIconColor: Material.color(Material.Blue)

    VCImg.Image {
        source: Store.state.productDetail.thumbnailSource
        fillMode: Image.PreserveAspectFit

        Layout.preferredWidth: 300
        Layout.preferredHeight: width / 1.75 // TODO: Can we fixate the aspect ratio?
    }

    VCF.LabeledColumnLayout {
        labelText: qsTr("Name")
        required: true
        spacing: Theme.spacingXS

        VCF.TextField {
            id: name

            placeholderText: qsTr("Enter name") + "..."
            font.pixelSize: Theme.fontSizeL
            text: Store.state.productDetail.name

            Layout.fillWidth: true
        }

        VCF.Error {
            id: nameErr

            text: L.Val.productName(root.name, Store.state.products.filter(p => p.name !== Store.state.productDetail.name), false)
        }
    }

    VCF.LabeledColumnLayout {
        labelText: qsTr("Description")

        VCF.TextArea {
            id: description

            textArea {
                font.pixelSize: Theme.fontSizeL
            }
            textAreaHeight: 150
            text: Store.state.productDetail.description
            placeholderText: qsTr("Enter description") + "..."

            Layout.fillWidth: true
        }
    }
}
