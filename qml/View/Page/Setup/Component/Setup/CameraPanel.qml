import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action.Camera as ACamera
import Action.Setup as ASetup
import Action.SetupCameraMeasCalib as ASetupCameraMeasCalib

import Lib as L
import Store
import Theme

import View.Component.Button as VCB
import View.Component.Camera as VCCam
import View.Component.ComboBox as VCCombo
import View.Component.Container as VCC
import View.Component.Form as VCF
import View.Component.Text as VCT

VCC.Pane {
    id: root

    required property var modelData

    readonly property string deviceID: modelData.deviceID

    readonly property int position: posSelect.currentValue ?? L.Con.CamPosition.Unknown
    readonly property string motorID: motorSelect.currentValue ?? ""
    
    padding: Theme.spacingXS

    states: [
        State {
            name: "motorTestDrive"
            when: Store.state.setup.motorTestDrive.active && Store.state.setup.motorTestDrive.cameraID === root.deviceID
            PropertyChanges { target: testDrive; text: qsTr("Cancel"); onClicked: ASetup.cancelCameraMotorTestDrive(Store.state.setup.motorTestDrive.callID) }
            PropertyChanges { target: assignMotor; enabled: false }
            PropertyChanges { target: calibrateFocus; enabled: false }
            PropertyChanges { target: calibrate; enabled: false }
        },
        State {
            name: "calibrateFocus"
            when: _.camera.calibratingFocus
            PropertyChanges { target: calibrateFocus; text: qsTr("Cancel"); onClicked: ACamera.cancelCalibrateFocus(_.camera.calibrateFocusCallID) }
            PropertyChanges { target: assignMotor; enabled: false }
            PropertyChanges { target: testDrive; enabled: false }
            PropertyChanges { target: calibrate; enabled: false }
        }
    ]

    QtObject {
        id: _

        readonly property var camera: Store.view.camera(root.deviceID)
    }

    RowLayout {
        anchors.fill: parent
        spacing: Theme.spacingS

        VCCam.Camera {
            id: cam

            modelData: root.modelData
            showPosition: false

            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignTop

            VCF.LabeledColumnLayout {
                labelText: qsTr("Position")
                label.font.pixelSize: Theme.fontSizeM
                required: true

                Layout.alignment: Qt.AlignTop

                VCCombo.ComboBox {
                    id: posSelect

                    function _elem(pos) {
                        return { name: L.Tr.camPosition(pos), value: pos }
                    }

                    textRole: "name"
                    valueRole: "value"
                    font.pixelSize: Theme.fontSizeM
                    popup.font.pixelSize: font.pixelSize
                    model: [
                        _elem(L.Con.CamPosition.Top),
                        _elem(L.Con.CamPosition.Front),
                        _elem(L.Con.CamPosition.Back),
                    ]

                    onActivated: ASetup.cameraAssignPosition(root.deviceID, currentValue)
                    
                    Component.onCompleted: setCurrentValue(root.modelData.position)
                }
            }

            VCF.HorDivider {}

            VCF.LabeledColumnLayout {
                labelText: qsTr("Motor") 
                label.font.pixelSize: Theme.fontSizeM
                required: true
                visible: Store.state.nline.hasMotorizedFocus
                spacing: Theme.spacingXS

                Layout.alignment: Qt.AlignTop

                VCCombo.ComboBox {
                    id: motorSelect

                    font.pixelSize: Theme.fontSizeM
                    popup.font.pixelSize: font.pixelSize
                    model: Store.state.motorIDs

                    Layout.fillWidth: true

                    Component.onCompleted: setCurrentValue(root.modelData.motorID)
                }

                RowLayout {
                    spacing: Theme.spacingXXS

                    Layout.alignment: Qt.AlignRight

                    VCB.Button {
                        id: assignMotor

                        text: qsTr("Assign")
                        enabled: motorSelect.currentIndex !== -1 && motorSelect.currentValue !== root.modelData.motorID
                        highlighted: true

                        onClicked: ASetup.cameraAssignMotor(root.deviceID, motorSelect.currentValue)
                    }

                    VCB.Button {
                        id: calibrateFocus

                        text: qsTr("Calibrate Focus")
                        enabled: root.modelData.motorID !== "" && !assignMotor.enabled

                        onClicked: ACamera.calibrateFocus(root.deviceID)
                    }

                    VCB.Button {
                        id: testDrive

                        text: qsTr("Test drive")
                        enabled: root.modelData.motorID !== "" && !assignMotor.enabled

                        onClicked: ASetup.cameraMotorTestDrive(root.deviceID)
                    }
                }
            }
        }

        VCF.VerDivider {}

        VCF.LabeledColumnLayout {
            label {
                text: qsTr("Measurement")
                font.pixelSize: Theme.fontSizeM
            }
            visible: Store.state.nline.hasMotorizedFocus
            spacing: Theme.spacingXS

            Layout.alignment: Qt.AlignTop

            VCF.LabeledRowLayout {
                spacing: Theme.spacingXXS

                label {
                    text: qsTr("Calibrated:")
                    font.weight: Font.Normal
                }

                VCT.ActiveIcon {
                    id: calibrated

                    state: _.camera.isMeasurementCalibrated ? "" : "inactive"

                    Layout.fillWidth: true
                }

                VCB.Button {
                    id: calibrate

                    text: qsTr("Calibrate")
                    highlighted: calibrated.state !== ""
                    enabled: root.motorID !== "" && !assignMotor.enabled

                    Layout.leftMargin: Theme.spacingS

                    onClicked: ASetupCameraMeasCalib.view(root.deviceID)
                }
            }

            VCF.LabeledRowLayout {
                label {
                    text: qsTr("Images:")
                    font.weight: Font.Normal
                }

                Text {
                    text: _.camera.measCalibImagesCount
                }
            }
        }

        Item { Layout.fillWidth: true }
    }
}
