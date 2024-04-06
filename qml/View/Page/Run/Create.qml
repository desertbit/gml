import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action as A
import Lib as L
import Store
import Theme

import View.Component.Button as VCB
import View.Component.Container as VCC

import "Component/Create"

import "create.js" as Logic

VCC.Page {
    id: root

    title: qsTr("New batch")

    ColumnLayout {
        id: content

        anchors {
            fill: parent
            margins: Theme.spacingS
        }
        spacing: Theme.spacingS

        VCB.Button {
            id: start

            text: qsTr("Start batch")
            state: "large"
            highlighted: true
            enabled: runPane.state === "valid"

            Layout.alignment: Qt.AlignRight

            onClicked: Logic.startSpool()
        }

        RowLayout {
            spacing: Theme.spacingS

            // First step : Select a product.
            ProductPane {
                id: productPane

                pageRoot: root

                Layout.preferredWidth: content.width * 0.3
                Layout.alignment: Qt.AlignTop

                onProductSelected: Logic.productSelected()
            }

            // Second step : Adjust sensitivity.
            SensitivityPane {
                id: sensitivityPane

                enabled: productPane.state === "valid"
                pageRoot: root

                Layout.preferredWidth: content.width * 0.25
                Layout.alignment: Qt.AlignTop

                onLoadDefaults: Logic.loadSensitivityDefaults()
            }

            // Third step : Enter the measurement settings.
            MeasurementPane {
                id: measurementPane

                enabled: sensitivityPane.state === "valid"

                Layout.preferredWidth: content.width * 0.25
                Layout.alignment: Qt.AlignTop

                onLoadDefaults: Logic.loadMeasurementDefaults()
            }

            // Fourth step : Enter the run data.
            RunDataPane {
                id: runPane

                enabled: measurementPane.state === "valid"

                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop

                onLoadDefaults: Logic.loadRunDataDefaults()
            }
        }

        Item { Layout.fillHeight: true } // Filler
    }
}
