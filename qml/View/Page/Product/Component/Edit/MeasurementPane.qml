import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Lib as L
import Store
import Theme

import View.Component.Form as VCF
import View.Component.Measurement as VCM

EditIconPane {
    id: root

    readonly property alias enableMeasurement: ctrl.enableMeasurement
    readonly property alias diameterNorm: ctrl.diameterNorm
    readonly property alias diameterUpperDeviation: ctrl.diameterUpperDeviation
    readonly property alias diameterLowerDeviation: ctrl.diameterLowerDeviation
    readonly property alias measurementWidth: ctrl.measurementWidth

    valid: L.Val.measurement(enableMeasurement, diameterNorm, diameterUpperDeviation, diameterLowerDeviation, measurementWidth)
    titleText: qsTr("Diameter measurement")
    titleIconName: "crosshair"
    titleIconColor: Material.color(Material.Green)
    spacing: Theme.spacingM

    VCM.Control {
        id: ctrl

        enableMeasurement: Store.state.productDetail.enableMeasurement
        diameterNorm: Store.state.productDetail.diameterNorm
        diameterUpperDeviation: Store.state.productDetail.diameterUpperDeviation
        diameterLowerDeviation: Store.state.productDetail.diameterLowerDeviation
        measurementWidth: Store.state.productDetail.measurementWidth
    }
}
