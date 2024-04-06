import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action as A
import Lib as L
import Store
import Theme

import View.Component.Dialog as VCD
import View.Component.Form as VCF

VCD.TrDialog {
    modal: false
    standardButtons: Dialog.Close
    closePolicy: Popup.CloseOnEscape
    header.visible: false // No title shown.

    onAboutToShow: A.ADev.subscribeKunbusState()
    onAboutToHide: A.ADev.unsubscribeKunbusState(Store.state.dev.kunbus.callID)

    component Group: ColumnLayout {
        default property alias children: groupContent.children
        property alias title: groupLabel.text

        spacing: Theme.spacingXS

        Label {
            id: groupLabel

            font {
                pixelSize: Theme.fontSizeL
                weight: Font.DemiBold
            }
        }

        RowLayout {
            id: groupContent

            spacing: Theme.spacingS
        }
    }
    component GroupItem: VCF.LabeledColumnLayout {
        property alias text: groupItemText.text

        Text {
            id: groupItemText

            font.pixelSize: Theme.fontSizeM
        }
    }

    ColumnLayout {
        id: content

        anchors.fill: parent
        spacing: Theme.spacingM

        Row {
            spacing: Theme.spacingXL

            Group {
                title: "State"

                GroupItem { labelText: "state";    text: L.State.name(Store.state.nline.state) }
                GroupItem { labelText: "progress"; text: L.LMath.roundToFixed(Store.state.nline.stateProgress, 4) }
            }

            Group {
                title: "StateErr"

                GroupItem { labelText: "code"; text: L.State.errCodeDebug(Store.state.nline.stateErr.code) }
                GroupItem { labelText: "msg"; text: Store.state.nline.stateErr.msg || "---" }
                GroupItem { labelText: "state"; text: L.State.name(Store.state.nline.stateErr.state) }
                GroupItem { labelText: "name"; text: Store.state.nline.stateErr.name || "---" }
            }
        }

        Group {
			title: "StateRun"

            GroupItem { labelText: "productID"; text: Store.state.nline.stateRun.productID }
            GroupItem { labelText: "productName"; text: Store.state.nline.stateRun.productName || "---" }
            GroupItem { labelText: "runID"; text: Store.state.nline.stateRun.runID }
            GroupItem { labelText: "runName"; text: Store.state.nline.stateRun.runName || "---" }
            GroupItem { labelText: "numErrors"; text: Store.state.nline.stateRun.numErrors }
            GroupItem { labelText: "numDefects"; text: Store.state.nline.stateRun.numDefects }
            GroupItem { labelText: "numMeasureDrifts"; text: Store.state.nline.stateRun.numMeasureDrifts }
        }

        Group {
			title: "StateTrain"

            GroupItem { labelText: "name"; text: Store.state.nline.stateTrain.name || "---" }
            GroupItem { labelText: "productName"; text: Store.state.nline.stateTrain.description || "---" }
            GroupItem { labelText: "created"; text: Store.state.nline.stateTrain.created.formatDateTime(Store.state.locale) }
            GroupItem { labelText: "retrain"; text: Store.state.nline.stateTrain.retrain }
            GroupItem { labelText: "recollectingImages"; text: Store.state.nline.stateTrain.recollectingImages }
            GroupItem { labelText: "cameraSetup"; text: Store.state.nline.stateTrain.cameraSetup }
        }

        Group {
			title: "StateClassify"

            GroupItem { labelText: "productID"; text: Store.state.nline.stateClassify.productID }
            GroupItem { labelText: "productName"; text: Store.state.nline.stateClassify.productName || "---" }
            GroupItem { labelText: "numRuns"; text: Store.state.nline.stateClassify.numRuns }
        }

        Group {
			title: "API-SystemInput"

            GroupItem { labelText: "enabled"; text: Store.state.dev.kunbus.input.system.enabled }
            GroupItem { labelText: "direction"; text: Store.state.dev.kunbus.input.system.direction }
            GroupItem { labelText: "resetError"; text: Store.state.dev.kunbus.input.system.resetError }
            GroupItem { labelText: "resetTriggerError"; text: Store.state.dev.kunbus.input.system.resetTriggerError }
            GroupItem { labelText: "samplingRate"; text: Store.state.dev.kunbus.input.system.samplingRate }
        }

        Group {
			title: "API-SystemOutput"

            GroupItem { labelText: "status"; text: Store.state.dev.kunbus.output.system.status }
            GroupItem { labelText: "apiVersion"; text: Store.state.dev.kunbus.output.system.apiVersion }
            GroupItem { labelText: "state"; text: L.State.name(Store.state.dev.kunbus.output.system.state) }
            GroupItem { labelText: "error"; text: Store.state.dev.kunbus.output.system.error }
            GroupItem { labelText: "triggerError"; text: Store.state.dev.kunbus.output.system.triggerError }
            GroupItem { labelText: "progress"; text: Store.state.dev.kunbus.output.system.progress }
        }

        Group {
			title: "API-RunInput"

            GroupItem { labelText: "startStop"; text: Store.state.dev.kunbus.input.run.startStop }
            GroupItem { labelText: "pauseResume"; text: Store.state.dev.kunbus.input.run.pauseResume }
            GroupItem { labelText: "livePosition"; text: Store.state.dev.kunbus.input.run.livePosition }
            GroupItem { labelText: "productID"; text: Store.state.dev.kunbus.input.run.productID || "---" }
            GroupItem { labelText: "runID"; text: Store.state.dev.kunbus.input.run.runID || "---" }
            GroupItem { labelText: "speed"; text: Store.state.dev.kunbus.input.run.speed }
            GroupItem { labelText: "position"; text: Store.state.dev.kunbus.input.run.position }
		}

        Group {
			title: "API-RunOutput"

            GroupItem { labelText: "errorFlag"; text: Store.state.dev.kunbus.output.run.errorFlag }
            GroupItem { labelText: "defectFlag"; text: Store.state.dev.kunbus.output.run.defectFlag }
            GroupItem { labelText: "measureDriftFlag"; text: Store.state.dev.kunbus.output.run.measureDriftFlag }
            GroupItem { labelText: "numErrors"; text: Store.state.dev.kunbus.output.run.numErrors }
            GroupItem { labelText: "numDefects"; text: Store.state.dev.kunbus.output.run.numDefects }
            GroupItem { labelText: "numMeasureDrifts"; text: Store.state.dev.kunbus.output.run.numMeasureDrifts }
		}

        Group {
			title: "API-TrainProductInput"

            GroupItem { labelText: "startStop"; text: Store.state.dev.kunbus.input.trainProduct.startStop }
        }
    }
}