import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action.EventDetail as AEventDetail
import Action.EventOverview as AEventOverview

import Lib as L
import Store
import Theme

import View.Component.AnomalyClass as VCA
import View.Component.Button as VCB
import View.Component.ComboBox as VCCombo
import View.Component.Container as VCC
import View.Component.Date as VCD
import View.Component.Event as VCE
import View.Component.Form as VCF
import View.Component.List as VCL
import View.Component.Measurement as VCM

import "Component/Overview"

import "overview.js" as Logic

VCC.Page {
    id: root

    title: (Store.state.eventOverview.skippedRunOverview ? qsTr("Batches") + " - " : "") +
           (Store.state.eventOverview.skippedRunDetail ? `${Store.state.eventOverview.skippedRunName} - ` : "") +
           qsTr("Events")

    Component.onCompleted: AEventOverview.setListLimit(list.numItems)

    VCL.HeaderBar {
        id: header

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        RowLayout {
            anchors.fill: parent
            spacing: Theme.spacingM

            // View selection.
            VCF.LabeledColumnLayout {
                labelText: qsTr("View")
                label.font.weight: Font.DemiBold
                spacing: 0

                VCCombo.ComboBox {
                    id: viewSelect

                    function _elem(value) { return { text: L.Tr.eventOverviewState(value), value: value } }

                    textRole: "text"
                    valueRole: "value"
                    model: {
                        let m = [
                            _elem(L.Con.EventOverviewState.List),
                            _elem(L.Con.EventOverviewState.Chart),
                            _elem(L.Con.EventOverviewState.Distribution)
                        ]
                        if (Store.state.eventOverview.measurement.enabled) {
                            m.push(_elem(L.Con.EventOverviewState.Measurement))
                        }
                        return m
                    }

                    // Initialize only once to the state.
                    // Otherwise, a language change will reset the selection to the state.
                    Component.onCompleted: setCurrentIndex(Store.state.eventOverview.viewState)
                }
            }

            VCF.LabeledColumnLayout {
                //: Temporal context, as in from Monday to Wednesday.
                labelText: qsTr("From")
                label.font.weight: Font.DemiBold
                spacing: 0

                VCD.TextField {
                    id: after

                    time: true
                    textField.font.pixelSize: Theme.fontSizeM
                    ts: Store.state.eventOverview.filter.afterTS
                    minDate: Store.state.eventOverview.filter.minTS
                    maxDate: before.ts.valid() ? before.ts : Store.state.eventOverview.filter.maxTS
                    defaultToMinDateWhenInvalid: true

                    onSelected: Logic.updateFilter()
                }
            }

            VCF.LabeledColumnLayout {
                //: Temporal context, as in from Monday to Wednesday.
                labelText: qsTr("To")
                label.font.weight: Font.DemiBold
                spacing: 0

                VCD.TextField {
                    id: before

                    time: true
                    textField.font.pixelSize: Theme.fontSizeM
                    ts: Store.state.eventOverview.filter.beforeTS
                    minDate: after.ts.valid() ? after.ts : Store.state.eventOverview.filter.minTS
                    maxDate: Store.state.eventOverview.filter.maxTS
                    defaultToMaxDateWhenInvalid: true

                    onSelected: Logic.updateFilter()
                }
            }

            VCF.LabeledColumnLayout {
                labelText: qsTr("Event type")
                label.font.weight: Font.DemiBold
                spacing: 4

                VCE.CodeSelect {
                    id: codeSelect

                    syncTo: Store.state.eventOverview.filter.eventCodes

                    onSelected: Logic.updateFilter()
                }
            }

            VCF.LabeledColumnLayout {
                labelText: qsTr("Anomaly class")
                label.font.weight: Font.DemiBold
                spacing: 4
                visible: viewSelect.currentIndex === 0

                Row {
                    Switch {
                        id: classSelectActive

                        onToggled: Logic.updateFilter()
                    }

                    VCA.ClassSelect {
                        id: classSelect

                        enabled: classSelectActive.checked

                        onSelected: Logic.updateFilter()
                    }
                }
            }

            VCB.Button {
                text: qsTr("Reset filter")
                enabled: after.ts.valid() || before.ts.valid() || !codeSelect.allSelected || classSelectActive.checked || !classSelect.currentClassIDs.empty()
                state: "medium"

                onClicked: Logic.resetFilter()
            }

            Item { Layout.fillWidth: true } // Filler

            VCF.LabeledColumnLayout {
                labelText: qsTr("Interval")
                label.font.weight: Font.DemiBold
                visible: viewSelect.currentIndex === 1 || viewSelect.currentIndex === 3

                VCCombo.TimeIntervalComboBox {
                    id: timeInterval

                    stateTimeInterval: Store.state.eventOverview.filter.timeInterval
                    stateTimeIntervals: Store.state.eventOverview.filter.timeIntervals

                    onActivated: Logic.updateFilter()
                }
            }

            VCL.PaginationControl {
                id: pageCtrl

                totalPages: Math.ceil(remainingElements / list.numItems)
                totalElements: Store.state.eventOverview.list.totalCount
                remainingElements: Store.state.eventOverview.list.filteredCount
                hideControls: viewSelect.currentIndex !== 0

                onPrev: AEventOverview.loadListPrevPage()
                onNext: AEventOverview.loadListNextPage()
            }
        }
    }

    StackLayout {
        id: stack

        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        // Syncs with the selected view.
        currentIndex: viewSelect.currentIndex

        List {
            id: list

            onEventTapped: id => AEventDetail.viewFromOverview(
                id,
                Store.state.eventOverview.runID,
                Store.state.eventOverview.productID,
                Store.state.eventOverview.filter.afterTS,
                Store.state.eventOverview.filter.beforeTS,
                Store.state.eventOverview.filter.eventCodes,
                Store.state.eventOverview.filter.anomalyClassIDs
            )
        }

        VCE.LineChart {
            changes: Store.state.eventOverview.chart.points
            maxPoints: 0
            enableToolTip: true
            legendBottomMargin: Theme.spacingS

            onPointSelected: (codes, afterTS, beforeTS) => Logic.applyChartPointFilter(codes, afterTS, beforeTS)
        }

        VCE.DistributionChart {
            model: Store.state.eventOverview.distribution.model
            legendBottomMargin: Theme.spacingS
        }

        VCM.Chart {
            changes: Store.state.eventOverview.measurement.points
            maxPoints: 0
            diameterNorm: Store.state.eventOverview.measurement.diameterNorm
            diameterMin: Store.state.eventOverview.measurement.diameterMin
            diameterMax: Store.state.eventOverview.measurement.diameterMax
            showPointLabels: true
        }
    }
}
