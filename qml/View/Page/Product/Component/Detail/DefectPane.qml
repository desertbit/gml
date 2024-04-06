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
import View.Component.Text as VCT

VCC.IconPane {
    id: root

    titleText: qsTr("Defect detection")
    titleIconName: "search"
    titleIconColor: Material.color(Material.Red)
    titleRightContent: [
        VCI.Icon {
            size: Theme.fontSizeXL
            name: "alert-triangle"
            color: Material.color(Material.Orange)
            visible: Store.state.productDetail.updateRequired
        },
        Text {
            id: title

            text: qsTr("Update required")
            font.weight: Font.DemiBold
            visible: Store.state.productDetail.updateRequired
        }
    ]

    RowLayout {
        spacing: Theme.spacingXL

        VCF.LabeledColumnLayout {
            labelText: qsTr("Last training")

            Text {
                font.pixelSize: Theme.fontSizeL
                text: Store.state.productDetail.lastTrained.formatDateTime(Store.state.locale)
            }
        }

        VCF.LabeledColumnLayout {
            //: Model as in AI model.
            labelText: qsTr("Model version")

            RowLayout {
                spacing: Theme.spacingXXS

                Text {
                    font.pixelSize: Theme.fontSizeL
                    text: Store.state.productDetail.backendVersion
                }

                VCI.Icon {
                    name: "arrow-right"
                    size: Theme.fontSizeS
                    visible: Store.state.productDetail.updateAvailable
                }

                Text {
                    font {
                        weight: Font.DemiBold
                        pixelSize: Theme.fontSizeL
                    }
                    text: qsTr("%1 available").arg(Store.state.nline.backendVersion)
                    visible: Store.state.productDetail.updateAvailable
                }
            }
        }
    }

    VCT.Info {
        text: (Store.state.productDetail.updateAvailable ?
                   qsTr("An update takes a similar amount of time as creating a new product.") :
                   qsTr("A retrain takes a similar amount of time as creating a new product.")) +
              (Store.state.productDetail.isMajorUpdate ? "\n" + qsTr("Please note that new gold sample images must be collected.") : "")
    }

    VCF.HorDivider {}

    RowLayout {
        spacing: Theme.spacingXL

        VCF.LabeledColumnLayout {
            labelText: qsTr("Train images")

            Text {
                font.pixelSize: Theme.fontSizeL
                //: As in the quantity.
                text: qsTr("Count %L1").arg(Store.state.productDetail.numTrainImages)
            }
        }

        VCF.LabeledColumnLayout {
            labelText: qsTr("Classification images")

            Text {
                font.pixelSize: Theme.fontSizeL
                //: As in the quantity.
                text: qsTr("Count %L1").arg(Store.state.productDetail.numCustomTrainImages)
            }
        }
    }

    VCF.HorDivider {}

    RowLayout {
        spacing: Theme.spacingL

        VCF.LabeledColumnLayout {
            labelText: qsTr("Sensitivity preset")

            Text {
                font.pixelSize: Theme.fontSizeL
                text: L.Tr.sensitivityPreset(Store.state.productDetail.sensitivityPreset)
            }
        }

        VCF.LabeledColumnLayout {
            labelText: qsTr("Sensitivity")
            visible: Store.state.productDetail.sensitivityPreset === L.Con.SensitivityPreset.Custom

            Text {
                font.pixelSize: Theme.fontSizeL
                text: `${Store.state.productDetail.customSensitivity}%`
            }
        }

        VCF.LabeledColumnLayout {
            labelText: qsTr("Min diameter(mm)")
            visible: Store.state.productDetail.sensitivityPreset === L.Con.SensitivityPreset.Custom

            Text {
                font.pixelSize: Theme.fontSizeL
                text: L.LMath.roundToFixed(Store.state.productDetail.customSensitivityDiameterMin, 2)
            }
        }
    }

    Item { Layout.fillHeight: true } // Filler
}
