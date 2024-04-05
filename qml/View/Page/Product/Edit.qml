import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action.ProductDetail as AProductDetail

import Lib as L
import Store
import Theme

import View.Component.Button as VCB
import View.Component.Container as VCC

import "Component/Edit"

VCC.Page {
    id: root

    title: qsTr("Edit")
    hasUnsavedChanges: _.unsavedChanges

    states: [
        State {
            name: "canSave"
            when: _.unsavedChanges && _.valid
            PropertyChanges { target: save; enabled: true }
        }
    ]

    QtObject {
        id: _

        readonly property var product: ({
            id: Store.state.productDetail.id,
            name: info.name,
            description: info.description,
            sensitivityPreset: sensitivity.preset,
            customSensitivity: sensitivity.sensitivity,
            customSensitivityDiameterMin: sensitivity.minDiameter,
            enableMeasurement: measurement.enableMeasurement,
            diameterNorm: measurement.diameterNorm,
            diameterUpperDeviation: measurement.diameterUpperDeviation,
            diameterLowerDeviation: measurement.diameterLowerDeviation,
            measurementWidth: measurement.measurementWidth
        })

        // True, if the forms contain unsaved changes.
        readonly property bool unsavedChanges: {
            // Copy the product, since we might overwrite the
            // custom sensitivity values for comparison reasons.
            const copy = L.Obj.copy(_.product, {})

            if (copy.sensitivityPreset !== L.Con.SensitivityPreset.Custom) {
                copy.customSensitivity = Store.state.productDetail.customSensitivity
                copy.customSensitivityDiameterMin = Store.state.productDetail.customSensitivityDiameterMin
            }

            // Check, if each property of our local state is equal to the one in the store.
            for (const key in copy) {
                if (copy[key] !== Store.state.productDetail[key]) {
                    return true
                }
            }
            return false
        }

        // True, if all forms contain valid inputs.
        readonly property bool valid: ![info.state, sensitivity.state, measurement.state].some(s => s === "invalid")
    }

    ColumnLayout {
        anchors {
            fill: parent
            margins: Theme.spacingS
        }
        spacing: Theme.spacingXS

        VCB.IconButton {
            id: save

            fontIcon {
                name: "save"
                size: Theme.iconSizeS
                color: Theme.colorOnAccent
            }
            text: qsTr("Save")
            horizontalPadding: Theme.spacingS
            highlighted: true
            enabled: false

            // Copy the product as we do not want to send our local pointer through the dispatcher.
            // The data might be modified in any way by e.g. middleware.
            onClicked: AProductDetail.update(L.Obj.copy(_.product, {}))
        }

        RowLayout {
            spacing: Theme.spacingS

            InfoPane {
                id: info

                Layout.preferredWidth: 400
                Layout.alignment: Qt.AlignTop
            }

            SensitivityPane {
                id: sensitivity

                Layout.preferredWidth: 500
                Layout.alignment: Qt.AlignTop
            }

            MeasurementPane {
                id: measurement

                Layout.preferredWidth: 400
                Layout.alignment: Qt.AlignTop
            }

            Item { Layout.fillWidth: true } // Filler
        }

        Item { Layout.fillHeight: true } // Filler
    }
}
