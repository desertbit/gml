import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action.State as AState

import Lib as L
import Theme
import Store

import View.Component.Button as VCB
import View.Component.Form as VCF

import "../Table"

Base {
    id: root

    spacing: Theme.spacingM

    titleRightContent: [
        VCB.Button {
            text: qsTr("Cancel")
            state: "medium"

            onClicked: AState.stopClassifyRuns()
        }
    ]

    RowLayout {
        spacing: Theme.spacingXS

        Table {
            Table.Label { text: qsTr("Product") + ":" }
            Table.Text { text: Store.state.nline.stateClassify.productName }

            Table.HorDivider {}

            Table.Label { text: qsTr("Number of batches") + ":" }
            Table.Text { text: Store.state.nline.stateClassify.numRuns }
        }
    }

    RowLayout {
        spacing: Theme.spacingXS

        ProgressBar {
            id: progressBar

            value: Store.state.nline.stateProgress

            Layout.fillWidth: true
        }
        Text {
            text: `${L.LMath.roundToFixed(progressBar.value*100, 0)}%`
            font.pixelSize: Theme.fontSizeL
        }
    }

    Item { Layout.fillHeight: true } // Filler
}
