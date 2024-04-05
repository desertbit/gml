import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action.CameraDetail as ACameraDetail
import Action.CameraFocus as ACameraFocus
import Action.ProductCreate as AProductCreate

import Lib as L
import Store
import Theme

import View.Component.Button as VCB
import View.Component.Camera as VCCam
import View.Component.Container as VCC
import View.Component.Dialog as VCD
import View.Component.Form as VCF
import View.Component.Product as VCP
import View.Component.Text as VCT

VCC.Page {
    id: root

    title: qsTr("New product")

    states: [
        State {
            name: "valid"
            when: name.text !== "" && !errMsg.visible
            PropertyChanges { target: action; enabled: true }
        }
    ]

    QtObject {
        id: _

        property int sensitivityPreset: Store.state.productDefaultSettings.sensitivityPreset
        property int customSensitivity: Store.state.productDefaultSettings.customSensitivity || L.Con.MinRecommendedSensitivity
        property real customSensitivityDiameterMin: Store.state.productDefaultSettings.customSensitivityDiameterMin
    }

    VCD.TrDialog {
        id: confirmDialog

        anchors.centerIn: parent
        title: qsTr("Start Training")
        modal: true
        standardButtons: Dialog.Ok | Dialog.Cancel

        onAccepted: AProductCreate.start(
            name.text,
            description.text,
            _.sensitivityPreset,
            _.customSensitivity,
            _.customSensitivityDiameterMin,
            !manualCamSetup.checked
        )

        ColumnLayout {
            anchors.fill: parent

            Text {
                text: qsTr("The gold sample images will be collected and used for training.")
                font.pixelSize: Theme.fontSizeXL
            }

            Text {
                text: qsTr("Please make sure the product is moving.")
                font.pixelSize: Theme.fontSizeXL
                font.weight: Font.DemiBold

                Layout.alignment: Qt.AlignHCenter
            }
        }
    }

    RowLayout {
        anchors {
            fill: parent
            margins: Theme.spacingS
        }
        spacing: Theme.spacingS

        // Camera column.
        VCCam.Cameras {
            onCameraClicked: deviceID => ACameraDetail.view(deviceID)
        }

        // Product info.
        VCC.IconPane {
            titleText: qsTr("Info")
            titleIconName: "info"
            titleIconColor: Theme.colorProduct
            contentSpacing: Theme.spacingL

            Layout.alignment: Qt.AlignTop
            Layout.preferredWidth: 500

            ColumnLayout {
                spacing: Theme.spacingXS

                RowLayout {
                    VCF.Label {
                        label: qsTr("Name")
                        required: true

                        Layout.fillWidth: true
                    }

                    VCF.Error {
                        id: errMsg

                        elide: Text.ElideRight
                        maximumLineCount: 1
                        text: L.Val.productName(name.text, Store.state.products, true)
                    }
                }

                VCF.TextField {
                    id: name

                    placeholderText: qsTr("Name...")
                    maximumLength: 32

                    Layout.fillWidth: true
                }
            }

            VCF.LabeledColumnLayout {
                labelText: qsTr("Description")

                VCF.TextArea {
                    id: description

                    placeholderText: qsTr("Description...")
                    textAreaHeight: 100

                    Layout.fillWidth: true
                }
            }

            // Divider
            Rectangle {
                color: Theme.colorBackgroundTier2

                Layout.preferredHeight: 2
                Layout.fillWidth: true
            }

            VCF.LabeledColumnLayout {
                labelText: qsTr("Default sensitivity")

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: qsTr("Sensitivity preset") + `: ${L.Tr.sensitivityPreset(_.sensitivityPreset)}`

                        Layout.fillWidth: true
                        Layout.topMargin: Theme.spacingS
                    }

                    VCB.Button {
                        text: qsTr("Adjust")

                        onClicked: {
                            ctrl.preset = _.sensitivityPreset
                            ctrl.sensitivity = _.customSensitivity
                            ctrl.minDiameter = _.customSensitivityDiameterMin
                            ctrl.loadCurrentValuesIntoForm()
                            ctrlPane.state = "open"
                        }
                    }
                }

                ColumnLayout {
                    visible: _.sensitivityPreset === L.Con.SensitivityPreset.Custom
                    spacing: Theme.spacingXS

                    Layout.fillWidth: true

                    Text { text: qsTr("Sensitivity") + `: ${_.customSensitivity}%` }
                    Text { text: qsTr("Min. error size") + ": " + qsTr("%L1mm").arg(L.LMath.roundToFixed(_.customSensitivityDiameterMin, 2)) }
                }
            }            

            ColumnLayout {
                spacing: -Theme.spacingS

                CheckBox {
                    id: manualCamSetup

                    text: qsTr("Manual camera setup")
                    font.pixelSize: Theme.fontSizeL
                    visible: Store.state.nline.hasMotorizedFocus
                }

                VCB.Button {
                    text: qsTr("Camera focus")
                    state: "medium"
                    highlighted: true
                    visible: manualCamSetup.checked

                    Layout.alignment: Qt.AlignRight

                    onClicked: ACameraFocus.view()
                }
            }

            // Divider
            Rectangle {
                color: Theme.colorBackgroundTier2

                Layout.preferredHeight: 2
                Layout.fillWidth: true
            }

            ColumnLayout {
                spacing: Theme.spacingS

                Text {
                    text: qsTr("Please make sure the product is moving at its intended production speed.")
                    font {
                        weight: Font.Bold
                        pixelSize: Theme.fontSizeL
                    }
                    wrapMode: Text.WordWrap

                    Layout.fillWidth: true
                }

                Text {
                    text: qsTr("As long as nLine is training a product, no batch can be started.")
                    font.pixelSize: Theme.fontSizeL
                    wrapMode: Text.WordWrap

                    Layout.fillWidth: true
                }
            }

            VCB.Button {
                id: action

                text: qsTr("Create")
                state: "large"
                highlighted: true
                enabled: false

                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: Theme.spacingS

                onClicked: confirmDialog.open()
            }
        }

        Item { Layout.fillWidth: true } // Filler
    }

    // The sensitivity control to change the sensitivity.
    VCC.Pane {
        id: ctrlPane

        x: (parent.width / 2) - (width / 2)
        y: parent.height
        parent: root
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
                            _.sensitivityPreset = ctrl.preset
                            _.customSensitivity = ctrl.sensitivity
                            _.customSensitivityDiameterMin = ctrl.minDiameter
                            ctrlPane.state = ""
                        }
                    }
                ]
            }

            Item { Layout.fillHeight: true } // Filler.
        }
    }
}
