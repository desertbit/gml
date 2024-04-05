import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Lib as L
import Store
import Theme

import View.Component.Button as VCB
import View.Component.Container as VCC
import View.Component.Form as VCF
import View.Component.Product as VCP

VCC.TickIconPane {
    id: root

    required property Item pageRoot

    // The selected sensitivity preset.
    property int preset
    // The custom sensitivity value, if preset is custom.
    property real sensitivity
    // The custom minDiameter value, if preset is custom.
    property real minDiameter

    // Emitted when the user presses the change button.
    signal change()
    // Emitted when the user presses the load defaults button.
    signal loadDefaults()

    titleText: "2. " + qsTr("Sensitivity")
    contentSpacing: Theme.spacingM

    states: [
        State {
            name: "valid"
            extend: "ticked"
            when: enabled
            PropertyChanges { target: preset; text: L.Tr.sensitivityPreset(root.preset) }
            PropertyChanges {
                target: sensitivity
                text: root.preset === L.Con.SensitivityPreset.Custom ? `${root.sensitivity}%` : "---"
            }
            PropertyChanges {
                target: minDiameter
                //: Abbreviation represents millimeter.
                text: root.preset === L.Con.SensitivityPreset.Custom ? qsTr("%L1mm").arg(L.LMath.roundToFixed(root.minDiameter, 2)) : "---"
            }
        }
    ]

    QtObject {
        id: _

        readonly property var product: Store.state.products.find(p => p.id === root.productID)
    }

    // The sensitivity control to change the sensitivity.
    VCC.Pane {
        id: ctrlPane

        x: (parent.width / 2) - (width / 2)
        y: parent.height
        parent: root.pageRoot
        width: parent.width * 0.35
        height: parent.height * 0.75

        states: [
            State {
                name: "open"
                PropertyChanges { target: ctrlPane; y: parent.height - height }
            }
        ]

        Behavior on y { NumberAnimation { duration: 120; property: "y" } }
    
        ColumnLayout {
            id: ctrlPaneContent

            anchors.fill: parent

            VCP.SensitivityControl {
                id: ctrl

                spacing: Theme.spacingS
                customColumnSpacing: Theme.spacingM
                presetRowChildren: [
                    VCB.Button {
                        text: qsTr("Cancel")
                        highlighted: true
                        flat: true

                        onClicked: ctrlPane.state = ""
                    },
                    VCB.Button {
                        text: qsTr("Apply")
                        highlighted: true

                        onClicked: {
                            root.preset = ctrl.preset
                            root.sensitivity = ctrl.sensitivity
                            root.minDiameter = ctrl.minDiameter
                            ctrlPane.state = ""
                        }
                    }
                ]
            }

            Item { Layout.fillHeight: true } // Filler.
        }
    }

    Text {
        font.pixelSize: Theme.fontSizeL
        text: qsTr("Defaults are loaded from the selected product.")
        color: enabled ? Theme.colorForeground : Theme.colorForegroundTier3
        wrapMode: Text.WordWrap

        Layout.fillWidth: true
    }

    VCF.LabeledColumnLayout {
        labelText: qsTr("Preset")
        label {
            font.pixelSize: Theme.fontSizeL
        }

        Text {
            id: preset

            font.pixelSize: Theme.fontSizeL
            color: enabled ? Theme.colorForeground : Theme.colorForegroundTier3
            text: "---"
        }
    }

    RowLayout {
        spacing: parent.spacing

        VCF.LabeledColumnLayout {
            labelText: qsTr("Sensitivity")
            label {
                font.pixelSize: Theme.fontSizeL
            }

            Text {
                id: sensitivity

                font.pixelSize: Theme.fontSizeL
                color: enabled ? Theme.colorForeground : Theme.colorForegroundTier3
                text: "---"

                Layout.fillWidth: true
            }
        }

        VCF.LabeledColumnLayout {
            labelText: qsTr("Min. error size")
            label {
                font.pixelSize: Theme.fontSizeL
            }

            Text {
                id: minDiameter

                font.pixelSize: Theme.fontSizeL
                color: enabled ? Theme.colorForeground : Theme.colorForegroundTier3
                text: "---"

                Layout.fillWidth: true
            }
        }
    }

    Item { Layout.fillHeight: true } // Filler

    RowLayout {
        VCB.Button {
        text: qsTr("Load defaults")
        
        onClicked: root.loadDefaults()
    }

        Item { Layout.fillWidth: true } // Filler

        Button {
            text: qsTr("Change")
            verticalPadding: 0
            horizontalPadding: Theme.spacingS
            font.capitalization: Font.MixedCase

            onClicked: {
                ctrl.preset = sensitivityPane.preset
                ctrl.sensitivity = sensitivityPane.sensitivity
                ctrl.minDiameter = sensitivityPane.minDiameter
                ctrl.loadCurrentValuesIntoForm()
                ctrlPane.state = "open"
            }
        }
    }
}
