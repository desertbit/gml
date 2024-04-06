import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action as A
import Lib as L
import Store.Model as SM
import Theme

import View.Component.Button as VCB
import View.Component.Container as VCC
import View.Component.Form as VCF
import View.Component.Icon as VCI
import View.Component.Text as VCT

VCC.IconPane {
    id: root

    required property SM.RunDetail model

    titleText: qsTr("Defect detection")
    titleIconName: "search"
    titleIconColor: Material.color(Material.Red)

    VCF.LabeledColumnLayout {
        //: Model as in AI model.
        labelText: qsTr("Model version")

        Text {
            font.pixelSize: Theme.fontSizeL
            text: root.model.backendVersion
        }
    }

    VCF.HorDivider {}

    RowLayout {
        spacing: Theme.spacingL

        VCF.LabeledColumnLayout {
            labelText: qsTr("Sensitivity preset")

            Text {
                font.pixelSize: Theme.fontSizeL
                text: L.Tr.sensitivityPreset(root.model.sensitivityPreset)
            }
        }

        VCF.LabeledColumnLayout {
            labelText: qsTr("Sensitivity")
            visible: root.model.sensitivityPreset === L.Con.SensitivityPreset.Custom

            Text {
                font.pixelSize: Theme.fontSizeL
                text: `${root.model.customSensitivity}%`
            }
        }
    }

    VCF.LabeledColumnLayout {
        labelText: qsTr("Min diameter(mm)")
        visible: root.model.sensitivityPreset === L.Con.SensitivityPreset.Custom

        Text {
            font.pixelSize: Theme.fontSizeL
            text: L.LMath.roundToFixed(root.model.customSensitivityDiameterMin, 2)
        }
    }

    Item { Layout.fillHeight: true } // Filler
}
