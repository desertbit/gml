import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action.ProductCreate as AProductCreate
import Action.ProductRetrain as AProductRetrain

import Lib as L
import Store
import Theme

import View.Component.Button as VCB
import View.Component.Form as VCF
import View.Component.Icon as VCI
import View.Component.Text as VCT

import "../Table"
import "Train"

Base {
    id: root

    spacing: Theme.spacingM

    titleRightContent: [
        VCB.Button {
            text: qsTr("Cancel")
            state: "medium"

            onClicked: {
                if (Store.state.nline.stateTrain.retrain) {
                    AProductRetrain.stop()
                } else {
                    AProductCreate.stop()
                }
            }
        }
    ]

    QtObject {
        id: _

        // Shorter aliases.
        readonly property QtObject stateTrain: Store.state.nline.stateTrain
        readonly property QtObject stateErr: Store.state.nline.stateErr
    }

    RowLayout {
        spacing: Theme.spacingXS

        Table {
            Table.Label { text: qsTr("Name") + ":" }
            Table.Text { text: _.stateTrain.name }

            Table.HorDivider {}

            Table.Label { text: qsTr("Started") + ":" }
            Table.Text { text: _.stateTrain.created.formatDateTime(Store.state.locale) }
        }

        Table.VerDivider {}

        Table {
            Table.Label { text: qsTr("Retrain") + ":" }
            VCT.ActiveIcon { 
                state: _.stateTrain.retrain ? "" : "inactive"
                label.font.pixelSize: 17
            }

            Table.HorDivider {}

            Table.Label { text: qsTr("Recollecting images") + ":" }
            VCT.ActiveIcon { 
                state: _.stateTrain.recollectingImages ? "" : "inactive"
                visible: _.stateTrain.retrain
                label.font.pixelSize: 17
            }
            Table.Text { text: "---"; visible: !_.stateTrain.retrain }

            Table.HorDivider {}

            Table.Label { text: qsTr("Manual camera setup") + ":"; visible: Store.state.nline.hasMotorizedFocus }
            VCT.ActiveIcon { 
                state: !_.stateTrain.cameraSetup ? "" : "inactive"
                label.font.pixelSize: 17
                visible: Store.state.nline.hasMotorizedFocus
            }
        }

        Table.VerDivider {}

        Table {
            Table.Label { text: qsTr("Sensitivity preset") + ":" }
            Table.Text { text: L.Tr.sensitivityPreset(_.stateTrain.sensitivityPreset) }

            Table.HorDivider {}

            Table.Label { text: qsTr("Sensitivity") + ":" }
            Table.Text {
                text: _.stateTrain.sensitivityPreset === L.Con.SensitivityPreset.Custom
                    ? _.stateTrain.customSensitivity + "%"
                    : "-"
            }

            Table.HorDivider {}

            Table.Label { text: qsTr("Min. error size") + ":" }
            Table.Text {
                text: _.stateTrain.sensitivityPreset === L.Con.SensitivityPreset.Custom
                    ? qsTr("%L1mm").arg(L.LMath.roundToFixed(_.stateTrain.customSensitivityDiameterMin, 2))
                    : "-"
            }
        }

        Table.VerDivider{}

        Table {
            Table.Label { text: qsTr("Description") + ":"; Layout.alignment: Qt.AlignTop }
            Table.Text {
                text: _.stateTrain.description || "---"
                maximumLineCount: 3
                wrapMode: Text.WordWrap
                elide: Text.ElideRight

                Layout.fillWidth: true
            }

            Table.HorDivider {}
        }
    }

    VCF.HorDivider { Layout.topMargin: -Theme.spacingXS }

    VCF.LabeledColumnLayout {
        labelText: qsTr("Progress")
        spacing: Theme.spacingM

        Steps {
            id: trainSteps

            model: {
                // Build model from state.
                const m = []
                if (_.stateTrain.cameraSetup) {
                    m.push(L.State.TrainProductCameraSetup)
                }
                if (!_.stateTrain.retrain || _.stateTrain.recollectingImages) {
                    m.push(L.State.TrainProductCollecting)
                }
                m.push(
                    L.State.TrainProductMeasuring,
                    L.State.TrainProductPreparingTraining,
                    L.State.TrainProductTraining,
                    L.State.TrainProductConverting
                )
                return m
            }

            Layout.fillWidth: true
            Layout.maximumWidth: 800
            Layout.fillHeight: true
            Layout.leftMargin: Theme.spacingS
        }
    }

    Item { Layout.fillHeight: true } // Filler
}
