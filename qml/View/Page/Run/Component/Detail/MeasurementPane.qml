import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import Action as A
import Lib as L
import Store.Model as SM
import Theme

import View.Component.Container as VCC
import View.Component.Measurement as VCM

VCC.IconPane {
    id: root

    required property SM.RunDetail model

    titleText: qsTr("Diameter measurement")
    titleIconName: "crosshair"
    titleIconColor: Material.color(Material.Green)

    VCM.Display {
        enableMeasurement: root.model.enableMeasurement
        diameterNorm: root.model.diameterNorm
        diameterUpperDeviation: root.model.diameterUpperDeviation
        diameterLowerDeviation: root.model.diameterLowerDeviation
        measurementWidth: root.model.measurementWidth
    }

    Item { Layout.fillHeight: true } // Filler
}
