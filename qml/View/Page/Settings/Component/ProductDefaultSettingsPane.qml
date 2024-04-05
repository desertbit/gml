import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action.Settings as ASettings

import Lib as L
import Store
import Theme

import View.Component.Button as VCB
import View.Component.Container as VCC
import View.Component.Form as VCF
import View.Component.Product as VCP

VCC.IconPane {
    id: root

    readonly property bool hasUnsavedChanges: ctrl.preset !== Store.state.productDefaultSettings.sensitivityPreset ||
                                              ctrl.sensitivity !== (Store.state.productDefaultSettings.customSensitivity || L.Con.MinRecommendedSensitivity) ||
                                              ctrl.minDiameter !== Store.state.productDefaultSettings.customSensitivityDiameterMin

    titleText: qsTr("Default values")
    titleIconName: "sliders"
    titleIconColor: Material.color(Material.Purple)
    contentSpacing: Theme.spacingS

    titleRightContent: RowLayout {
        VCB.Button {
            text: qsTr("Reset")
            enabled: root.hasUnsavedChanges

            onClicked: {
                ctrl.preset = Store.state.productDefaultSettings.sensitivityPreset
                ctrl.sensitivity = Store.state.productDefaultSettings.customSensitivity || L.Con.MinRecommendedSensitivity
                ctrl.minDiameter = Store.state.productDefaultSettings.customSensitivityDiameterMin
                ctrl.loadCurrentValuesIntoForm()
            }
        }

        VCB.Button {
            text: qsTr("Apply")
            highlighted: true
            enabled: root.hasUnsavedChanges

            onClicked: ASettings.updateDefaultProductSettings(ctrl.preset, ctrl.sensitivity, ctrl.minDiameter)
        }
    }

    VCF.LabeledColumnLayout {
        labelText: qsTr("Sensitivity")
        label.font.pixelSize: Theme.fontSizeL

        Layout.alignment: Qt.AlignTop

        VCP.SensitivityControl {
            id: ctrl

            preset: Store.state.productDefaultSettings.sensitivityPreset
            sensitivity: Store.state.productDefaultSettings.customSensitivity || L.Con.MinRecommendedSensitivity
            minDiameter: Store.state.productDefaultSettings.customSensitivityDiameterMin

            Component.onCompleted: loadCurrentValuesIntoForm()
        }
    }
}
