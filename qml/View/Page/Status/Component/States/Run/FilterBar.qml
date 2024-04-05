import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action.EventOverview as AEventOverview
import Action.RunActive as ARunActive

import Lib as L
import Store
import Theme

import View.Component.ComboBox as VCCombo
import View.Component.Container as VCC
import View.Component.Event as VCE
import View.Component.Form as VCF

VCC.Pane {
    id: root

    required property int currentBarIndex

    property real labelFontSize: Theme.fontSizeM

    QtObject {
        id: _

        function updateFilter() {
            ARunActive.setFilter(eventCodes.currentCodes, timeRange.currentValue, timeInterval.currentValue)
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: Theme.spacingM

        VCF.LabeledRowLayout {
            labelText: qsTr("Current error") + ":"
            label.font {
                weight: Font.DemiBold
                pixelSize: Theme.fontSizeM
            }
            visible: root.currentBarIndex === 0

            Text {
                font {
                    weight: root.runActive ? Font.DemiBold : Font.Normal
                    pixelSize: Theme.fontSizeXL
                }
                color: Store.state.runActive.stats.err === L.Con.RunErr.NoErr ? Theme.colorForegroundTier2 : Theme.error
                text: L.Tr.runErr(Store.state.runActive.stats.err) || "---"

                Layout.fillWidth: true
            }
        }

        // EventGraph
        VCF.LabeledRowLayout {
            labelText: qsTr("Time range")
            label.font.pixelSize: root.labelFontSize
            visible: root.currentBarIndex !== 0

            TimeRangeComboBox {
                id: timeRange

                syncTo: Store.state.runActive.filter.timeRange

                onActivated: _.updateFilter()
            }
        }

        VCF.LabeledRowLayout {
            labelText: qsTr("Interval")
            label.font.pixelSize: root.labelFontSize
            visible: root.currentBarIndex === 1 || root.currentBarIndex === 3

            VCCombo.TimeIntervalComboBox {
                id: timeInterval

                stateTimeInterval: Store.state.runActive.filter.timeInterval
                stateTimeIntervals: Store.state.runActive.filter.timeIntervals

                onActivated: _.updateFilter()
            }
        }

        // Filler
        Item { Layout.fillWidth: true }

        VCF.LabeledRowLayout {
            labelText: qsTr("Event type")
            label.font.pixelSize: root.labelFontSize
            visible: root.currentBarIndex !== 3

            VCE.CodeSelect {
                id: eventCodes

                syncTo: Store.state.runActive.filter.eventCodes

                onSelected: _.updateFilter()
            }
        }

        Button {
            //: An event is an error that has been captured.
            text: qsTr("View all events")
            font {
                pixelSize: Theme.fontSizeM
            }
            horizontalPadding: Theme.spacingS
            verticalPadding: Theme.spacingXXS
            font.capitalization: Font.MixedCase

            onClicked: AEventOverview.viewFromStatus()
        }
    }
}
