import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action.Camera as ACamera

import Lib as L
import Store
import Theme

import View.Component.Button as VCB
import View.Component.ComboBox as VCCombo
import View.Component.Container as VCC

VCC.Pane {
    id: root

    // The current Model.Camera object.
    required property var camera

    states: [
        State {
            name: "disabled"
            PropertyChanges { target: calibrateFocus; enabled: false }
            PropertyChanges { target: autofocus; enabled: false }
            PropertyChanges { target: moveBack; enabled: false }
            PropertyChanges { target: moveForward; enabled: false }
        },
        State {
            name: "autofocus"
            when: root.camera.autofocusing
            extend: "disabled"
            PropertyChanges {
                target: autofocus
                text: qsTr("Cancel")
                onClicked: ACamera.cancelAutofocus(root.camera.autofocusCallID)
                highlighted: false
                enabled: true
            }
        },
        State {
            name: "calibrateFocus"
            when: root.camera.calibratingFocus
            extend: "disabled"
        },
        State {
            name: "moving"
            when: root.camera.moving
            extend: "disabled"
        }
    ]

    RowLayout {
        anchors.fill: parent
        spacing: Theme.spacingM

        Layout.alignment: Qt.AlignTop

        VCB.Button {
            id: autofocus

            text: qsTr("Autofocus")
            highlighted: true
            state: "medium"

            onClicked: ACamera.autofocus(root.camera.deviceID)
        }

        VCB.RoundIconButton {
            id: moveBack

            highlighted: true
            fontIcon {
                color: Theme.colorOnAccent
                name: "minus"
            }
            enabled: root.camera.focus.stepPos > 0

            onClicked: ACamera.setFocusStepPos(root.camera.deviceID, Math.max(root.camera.focus.stepPos - focusShift.step, 0))
        }

        Column {
            spacing: -10

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Focus shift: %L1%").arg(L.LMath.roundToFixed(focusShift.value*100, 2))
            }

            Slider {
                id: focusShift

                readonly property real step: Math.round(root.camera.focus.maxSteps * value)

                width: 300
                from: stepSize
                to: 0.1
                stepSize: 0.005
            }
        }

        VCB.RoundIconButton {
            id: moveForward

            highlighted: true
            fontIcon {
                color: Theme.colorOnAccent
                name: "plus"
            }
            enabled: root.camera.focus.stepPos < root.camera.focus.maxSteps

            onClicked: ACamera.setFocusStepPos(root.camera.deviceID, Math.min(root.camera.focus.stepPos + focusShift.step, root.camera.focus.maxSteps))
        }

        VCB.Button {
            id: calibrateFocus

            text: qsTr("Calibrate focus")

            onClicked: ACamera.calibrateFocus(root.camera.deviceID)
        }
    }
}
