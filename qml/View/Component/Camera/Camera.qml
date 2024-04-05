import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Gml

import Action.Camera as ACamera

import Lib as L
import Theme

import View.Component.Button as VCB
import View.Component.Handler as VCH
import View.Component.Text as VCT

Rectangle {
    id: root

    required property var modelData

    // If true, the component can be tapped which emits the clicked signal.
    property alias interactive: tap.enabled
    // If true, the component shows a play/pause button that allows to play/pause the stream.
    property alias showPause: pause.visible
    // If true, a small text in the upper right corner displays the position of the camera.
    property alias showPosition: position.visible
    // If true, a bar is shown that displays focus position changes.
    property alias showFocusPosBar: focusPosBar.visible
    // If true, a text tag is displayed showing the current operation running on the camera.
    property bool showBusyTag: true
    // The transformation mode of the GML.ImageItem.
    property alias transformationMode: img.transformationMode

    // Emitted when a user taps onto the component.
    // Only works, if interactive is true.
    signal clicked()

    // Background color.
    color: "black"
    implicitWidth: Math.floor(height / modelData.aspectRatio)

    states: [
        State {
            name: "paused"
            when: root.modelData.paused
            PropertyChanges { target: pause; fontIcon.name: "play"; onClicked: ACamera.resumeStream(root.modelData.deviceID) }
        },
        State {
            name: "autofocus"
            when: root.modelData.autofocusing && root.showBusyTag
            PropertyChanges { target: pulsatingTag; visible: true; text: qsTr("Autofocus") + "..." }
        },
        State {
            name: "calibratingFocus"
            when: root.modelData.calibratingFocus && root.showBusyTag
            PropertyChanges { target: pulsatingTag; visible: true; text: qsTr("Calibrating focus") + "..." }
        }
    ]

    ImageItem {
        id: img

        anchors {
            fill: parent
            margins: 1
        }
        source: modelData.deviceID
        aspectRatioMode: Qt.KeepAspectRatio
        transformationMode: Qt.FastTransformation

        VCH.Tap {
            id: tap

            onTapped: root.clicked()
        }

        // Camera stream label.
        Rectangle {
            anchors.fill: position
            color: Theme.halfTransparentBlack
            radius: 4
            visible: position.visible
        }

        // The label showing the position.
        Text {
            id: position

            anchors {
                right: parent.right
                top: parent.top
                rightMargin: Theme.spacingXXS
                topMargin: Theme.spacingXXS
            }
            topPadding: Theme.spacingXXXS
            bottomPadding: Theme.spacingXXXS
            leftPadding: Theme.spacingXXS
            rightPadding: Theme.spacingXXS
            color: "white"
            font.pixelSize: Theme.fontSizeS
            text: L.Tr.camPosition(root.modelData.position)
        }

        // Button to pause and resume.
        VCB.RoundIconButton {
            id: pause

            anchors {
                bottom: parent.bottom
                right: parent.right
                margins: Theme.spacingXXS
            }
            flat: true
            fontIcon {
                name: "pause"
                color: "white"
                font.pixelSize: Theme.fontSizeL
            }
            visible: false

            onClicked: ACamera.pauseStream(root.modelData.deviceID)
        }

        // Overlay tag to show busy operation.
        VCT.PulsatingTag {
            id: pulsatingTag

            anchors {
                bottom: focusPosBar.visible ? focusPosBar.top : parent.bottom
                bottomMargin: Theme.spacingXS
                horizontalCenter: parent.horizontalCenter
            }
            visible: false
        }

        // Focus position bar.
        FocusPositionBar {
            id: focusPosBar

            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                bottomMargin: Theme.spacingM
                leftMargin: Theme.spacingXXL
                rightMargin: Theme.spacingXXL
            }
            camera: root.modelData
            visible: false
        }
    }
}
