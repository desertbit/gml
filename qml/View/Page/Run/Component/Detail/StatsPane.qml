import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action.EventOverview as AEventOverview

import Lib as L
import Store.Model as SM
import Theme

import View.Component.Button as VCB
import View.Component.ComboBox as VCCombo
import View.Component.Container as VCC
import View.Component.Event as VCE
import View.Component.Form as VCF
import View.Component.Measurement as VCM

VCC.IconPane {
    id: root

    required property SM.RunDetail model

    titleText: qsTr("Statistics")
    titleIconName: "bar-chart-2"
    titleIconColor: Material.color(Material.Orange)
    titleRightContentSpacing: Theme.spacingXS
    titleRightContent: [
        VCCombo.ComboBox {
            id: viewSelection

            function _elem(value) { return { text: L.Tr.eventOverviewState(value), value: value } }

            textRole: "text"
            valueRole: "value"
            model: {
                let m = [
                    _elem(L.Con.EventOverviewState.Distribution),
                    _elem(L.Con.EventOverviewState.Chart)
                ]
                if (root.model.enableMeasurement) {
                    m.push(_elem(L.Con.EventOverviewState.Measurement))
                }
                return m
            }
        },
        VCB.Button {
            text: qsTr("View Details")

            onClicked: AEventOverview.viewFromRunDetail(root.model.productID, root.model.id, viewSelection.currentValue)
        }
    ]

    StackLayout {
        currentIndex: viewSelection.currentIndex

        Layout.fillWidth: true
        Layout.fillHeight: true

        VCE.DistributionChart {
            model: root.model.eventDistribution
        }

        VCE.LineChart {
            changes: root.model.aggrEvents
            maxPoints: 0
            scatterSize: 7
        }

        VCM.Chart {
            changes: root.model.aggrMeasurePoints
            maxPoints: 0
            diameterNorm: root.model.diameterNorm
            diameterMin: root.model.diameterNorm - root.model.diameterLowerDeviation
            diameterMax: root.model.diameterNorm + root.model.diameterUpperDeviation
        }
    }
}
