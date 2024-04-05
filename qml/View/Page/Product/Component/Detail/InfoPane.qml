import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Store
import Theme

import View.Component.Button as VCB
import View.Component.Container as VCC
import View.Component.Form as VCF
import View.Component.Image as VCI

VCC.IconPane {
    id: root

    titleText: qsTr("Info")
    titleIconName: "info"
    titleIconColor: Material.color(Material.Blue)

    RowLayout {
        spacing: Theme.spacingXS

        VCI.Image {
            source: Store.state.productDetail.thumbnailSource
            fillMode: Image.PreserveAspectFit

            Layout.preferredWidth: 300
            Layout.preferredHeight: width / 1.75 // TODO: Can we fixate the aspect ratio?
        }

        ColumnLayout {
            spacing: Theme.spacingS

            VCF.LabeledColumnLayout {
                labelText: qsTr("Name")

                Text {
                    text: Store.state.productDetail.name
                    font.pixelSize: Theme.fontSizeL
                    maximumLineCount: 1
                    elide: Text.ElideRight

                    Layout.fillWidth: true
                }
            }

            VCF.LabeledColumnLayout {
                labelText: qsTr("Created on")

                Text {
                    font.pixelSize: Theme.fontSizeL
                    text: Store.state.productDetail.created.formatDateTime(Store.state.locale)
                    maximumLineCount: 1
                    elide: Text.ElideRight

                    Layout.fillWidth: true
                }
            }

            VCF.LabeledColumnLayout {
                labelText: qsTr("Updated on")

                Text {
                    font.pixelSize: Theme.fontSizeL
                    text: Store.state.productDetail.updated.formatDateTime(Store.state.locale)
                    maximumLineCount: 1
                    elide: Text.ElideRight

                    Layout.fillWidth: true
                }
            }
        }
    }

    VCF.LabeledColumnLayout {
        labelText: qsTr("Description")

        Text {
            font.pixelSize: Theme.fontSizeL
            text: Store.state.productDetail.description || "---"
            wrapMode: Text.WordWrap

            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
