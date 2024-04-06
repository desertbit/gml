import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import Action as A
import Lib as L
import Store
import Theme

import View.Component.Product as VCP

EditIconPane {
    id: root

    property alias preset: ctrl.preset
    property alias sensitivity: ctrl.sensitivity
    property alias minDiameter: ctrl.minDiameter

    valid: ctrl.valid
    titleText: qsTr("Sensitivity")
    titleIconName: "search"
    titleIconColor: Material.color(Material.Indigo, Material.Shade600)
    spacing: Theme.spacingM

    Text {
        wrapMode: Text.WordWrap
        text: qsTr(
            "The sensitivity determines how sensitive nLine is towards detecting errors.\n"+
            "A lower sensitivity will usually detect only severe defects, while a higher one will also catch minor defects.\n"+
            "You can choose one of the presets or set your own custom values."
        )

        Layout.fillWidth: true
    }

    VCP.SensitivityControl {
        id: ctrl

        preset: Store.state.productDetail.sensitivityPreset
        sensitivity: Store.state.productDetail.customSensitivity || L.Con.MinRecommendedSensitivity
        minDiameter: Store.state.productDetail.customSensitivityDiameterMin

        Component.onCompleted: loadCurrentValuesIntoForm()
    }
}
