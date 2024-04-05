import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action.SetupCameraMeasCalib as ASetupCameraMeasCalib

import Store
import Theme

import View.Component.Button as VCB
import View.Component.Container as VCC
import View.Component.Form as VCF

VCC.IconPane {
    id: root

    // Emitted when a new image has been captured and added.
    signal added()

    titleText: qsTr("Add image")
    title.font.pixelSize: Theme.fontSizeL
    // Disable all controls whilst the camera is moving.
    enabled: !_.camera.autofocusing && !_.camera.calibratingFocus && !_.camera.moving

    states: [
        State {
            name: "preview"
            when: Store.state.setupCameraMeasCalib.preview.active
            PropertyChanges { target: capture; visible: false }
            PropertyChanges { target: addDiscardRow; visible: true }
        }
    ]

    QtObject {
        id: _
        
        readonly property var camera: Store.view.camera(Store.state.setupCameraMeasCalib.cameraID)
    }

    Text {
        color: enabled ? Theme.colorForeground : Theme.colorForegroundTier3
        text: qsTr("Measuring rod diameter (mm)")
        font.pixelSize: Theme.fontSizeM
        wrapMode: Text.WordWrap

        Layout.fillWidth: true
    }

    VCF.TextField {
        id: diameter

        placeholderText: qsTr("Enter diameter" + "...")
        inputMethodHints: Qt.ImhDigitsOnly
        validator: DoubleValidator { 
            bottom: 0.1
            top: 1000
            locale: "en"
        }

        Layout.fillWidth: true
        Layout.bottomMargin: Theme.spacingS
    }

    CheckBox {
        id: autofocus

        text: qsTr("Automatic autofocus")
        checked: true
    }

    VCB.Button {
        id: capture

        text: qsTr("Capture")
        state: "medium"
        highlighted: true
        enabled: diameter.acceptableInput

        Layout.alignment: Qt.AlignHCenter

        onClicked: ASetupCameraMeasCalib.previewCapture(Store.state.setupCameraMeasCalib.cameraID, parseFloat(diameter.text), autofocus.checked)
    }

    Row {
        id: addDiscardRow

        spacing: Theme.spacingS
        visible: false

        VCB.Button {
            text: qsTr("Discard")
            state: "medium"

            onClicked: ASetupCameraMeasCalib.discardCapture()
        }

        VCB.Button {
            text: qsTr("Add")
            highlighted: true
            state: "medium"

            onClicked: ASetupCameraMeasCalib.addCapture(
                Store.state.setupCameraMeasCalib.cameraID,
                Store.state.setupCameraMeasCalib.preview.diameter,
                Store.state.setupCameraMeasCalib.preview.stepPos,
                Store.state.setupCameraMeasCalib.preview.pixels
            ).then(root.added)
        }
    }
}
