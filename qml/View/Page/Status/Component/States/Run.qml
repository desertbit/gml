import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action.RunActive as ARunActive

import Lib as L
import Theme
import Store

import View.Component.Button as VCB
import View.Component.Event as VCE
import View.Component.Form as VCF
import View.Component.Icon as VCI
import View.Component.Measurement as VCM
import View.Component.Text as VCT

import "../Table"
import "Run"

Base {
    id: root

    titleRightContent: [
        VCB.Button {
            id: pause

            state: "medium"
            text: qsTr("Pause")

            onClicked: ARunActive.pause()
        },
        VCB.Button {
            state: "medium"
            text: qsTr("Finish")
            highlighted: true

            onClicked: ARunActive.finish()
        }
    ]

    states: [
        State {
            name: "paused"
            when: Store.state.nline.state === L.State.RunPaused
            PropertyChanges { target: pause; text: qsTr("Resume"); onClicked: ARunActive.resume() }
        }
    ]

    QtObject {
        id: _

        readonly property bool measEnabled: Store.state.runActive.enableMeasurement
        readonly property bool sensCustom: Store.state.runActive.sensitivityPreset === L.Con.SensitivityPreset.Custom
    }

    // Use slightly smaller font sizes to display all information properly.
    component TableLabel: Table.Label { font.pixelSize: 14 }
    component TableText: Table.Text { font.pixelSize: 17 }

    RowLayout {
        spacing: Theme.spacingXS

        Table {
            TableLabel { text: qsTr("Product") + ":" }
            TableText { id: productName; text: Store.state.nline.stateRun.productName }

            Table.HorDivider {}

            TableLabel { text: qsTr("Batch") + ":" }
            TableText { id: runName; text: Store.state.nline.stateRun.runName }

            Table.HorDivider {}

            TableLabel {
                //: Abbreviation for description.
                text: qsTr("Descr.") + ":"
            
                Layout.alignment: Qt.AlignTop
            }
            TableText {
                text: Store.state.runActive.product.description || "---"
                wrapMode: Text.WordWrap
                elide: Text.ElideRight
                maximumLineCount: 3

                // The description should be at max as wide as the run or product label above.
                Layout.maximumWidth: Math.max(productName.implicitWidth, runName.implicitWidth)
                Layout.fillWidth: true
            }
        }

        Table.VerDivider {}

        Table {
            columns: 4

            TableLabel { text: qsTr("Speed (m/min)"); Layout.columnSpan: parent.columns }

            Table.HorDivider {}

            TableLabel { text: qsTr("Current") + ":" }
            TableText { text: L.LMath.roundToFixed(Store.state.runActive.stats.speed.current/100, 2) }
            TableLabel { text: qsTr("Avg.") + ":" }
            TableText { text: L.LMath.roundToFixed(Store.state.runActive.stats.speed.avg/100, 2) }

            Table.HorDivider {}

            TableLabel { text: qsTr("Min.") + ":" }
            TableText { text: L.LMath.roundToFixed(Store.state.runActive.stats.speed.min/100, 2) }
            TableLabel { text: qsTr("Max.") + ":"  }
            TableText { text: L.LMath.roundToFixed(Store.state.runActive.stats.speed.max/100, 2) }

            Table.HorDivider {}

            TableLabel { text: qsTr("Position") + ":" }
            TableText {
                //: Abbreviation for meter.
                text: qsTr("%L1m").arg(L.LMath.roundToFixed(Store.state.runActive.stats.position.current/100, 2))
                Layout.columnSpan: parent.columns - 1
            }
        }

        Table.VerDivider {}

        Table {
            columns: 4

            TableLabel { text: qsTr("Measurement (mm)"); Layout.columnSpan: parent.columns }

            Table.HorDivider {}

            TableLabel { text: qsTr("Active") + ":" }
            VCT.ActiveIcon {
                state: _.measEnabled ? "" : "inactive"
                icon.size: Theme.iconSizeXS
                label.font.pixelSize: 17

                Layout.columnSpan: parent.columns - 1
            }

            Table.HorDivider {}

            TableLabel {
                //: The target value of the measurement.
                text: qsTr("Target") + ":"
            }
            TableText { text: _.measEnabled ? L.LMath.roundToFixed(Store.state.runActive.diameterNorm, L.Con.MeasDec) : "---" }
            TableLabel {
                //: The width of the measurement.
                text: qsTr("Width") + ":"
            }
            TableText { text: _.measEnabled ? L.LMath.roundToFixed(Store.state.runActive.measurementWidth, L.Con.MeasDec) : "---" }

            Table.HorDivider {}

            TableLabel {
                //: The positive deviation from the target value of the measurement.
                text: qsTr("+ Dev.") + ":"
            }
            TableText { text: _.measEnabled ? L.LMath.roundToFixed(Store.state.runActive.diameterUpperDeviation, L.Con.MeasDec) : "---" }
            TableLabel {
                //: The negative deviation from the target value of the measurement.
                text: qsTr("- Dev.") + ":"
            }
            TableText { text: _.measEnabled ? L.LMath.roundToFixed(Store.state.runActive.diameterLowerDeviation, L.Con.MeasDec) : "---" }
        }

        Table.VerDivider {}

        Table {
            TableLabel { text: qsTr("Sensitivity"); Layout.columnSpan: parent.columns }

            Table.HorDivider {}

            TableLabel { text: qsTr("Preset") + ":" }
            TableText { text: L.Tr.sensitivityPreset(Store.state.runActive.sensitivityPreset) }

            Table.HorDivider {}

            TableLabel { text: qsTr("Value") + ":" }
            TableText { text: _.sensCustom ? `${Store.state.runActive.customSensitivity}%` : "---" }

            Table.HorDivider {}

            TableLabel { text: qsTr("Min. size") + ":" }
            TableText {
                //: Abbreviation for millimeter.
                text: _.sensCustom ? qsTr("%L1mm").arg(Store.state.runActive.customSensitivityDiameterMin) : "---" 
            }
        }

        Table.VerDivider {}

        Table {
            columns: 1

            TableLabel { text: qsTr("Created") + ":" }

            Table.HorDivider {}

            TableText { text: Store.state.runActive.created.formatDateTime(Store.state.locale) }

            Table.HorDivider {}

            TableLabel { text: qsTr("Paused") + ":" }

            Table.HorDivider {}

            TableText { 
                text: {
                    const p = Store.state.runActive.pauses.last()
                    if (!p || Store.state.nline.state !== L.State.RunPaused) {
                        return "---"
                    }
                    return p.paused.formatDateTime(Store.state.locale)
                }
            }
        }
    }

    VCF.HorDivider {}

    TabBarHeader {
        id: tabBarHeader

        Layout.fillWidth: true
    }

    FilterBar {
        currentBarIndex: tabBarHeader.currentIndex

        Layout.fillWidth: true
    }

    StackLayout {
        currentIndex: tabBarHeader.currentIndex

        LiveEventsList {}

        VCE.LineChart {
            changes: Store.state.runActive.aggrEvents.changes
            maxPoints: Store.state.runActive.maxGraphPoints
        }

        VCE.DistributionChart {
            model: Store.state.runActive.eventDistribution.model
        }

        VCM.Chart {
            changes: Store.state.runActive.aggrMeasurePoints.model
            maxPoints: Store.state.runActive.maxGraphPoints
            diameterNorm: Store.state.runActive.diameterNorm
            diameterMin: Store.state.runActive.diameterNorm - Store.state.runActive.diameterLowerDeviation
            diameterMax: Store.state.runActive.diameterNorm + Store.state.runActive.diameterUpperDeviation
        }
    }
}
