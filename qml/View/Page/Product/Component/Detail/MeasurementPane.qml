import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import Action as A
import Lib as L
import Store
import Theme

import View.Component.Container as VCC
import View.Component.Measurement as VCM

VCC.IconPane {
    id: root

    titleText: qsTr("Diameter measurement")
    titleIconName: "crosshair"
    titleIconColor: Material.color(Material.Green)

    VCM.Display {
        enableMeasurement: Store.state.productDetail.enableMeasurement
        diameterNorm: Store.state.productDetail.diameterNorm
        diameterUpperDeviation: Store.state.productDetail.diameterUpperDeviation
        diameterLowerDeviation: Store.state.productDetail.diameterLowerDeviation
        measurementWidth: Store.state.productDetail.measurementWidth
    }

    Item { Layout.fillHeight: true } // Filler
}
