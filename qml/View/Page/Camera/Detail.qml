import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action as A
import Lib as L
import Store
import Theme

import View.Component.Button as VCB
import View.Component.Camera as VCCam
import View.Component.Container as VCC

VCC.Page {
    id: root

    //: Argument is the position of the camera (e.g. Top)
    title: qsTr("%1 Camera").arg(L.Tr.camPosition(camera.modelData.position))

    states: [
        State {
            name: "paused"
            when: camera.modelData.paused
            PropertyChanges { target: pauseResume; fontIcon.name: "play"; onClicked: A.ACamera.resumeStream(Store.state.cameraDetail.deviceID) }
        }
    ]

    VCCam.Camera {
        id: camera

        anchors.fill: parent
        modelData: Store.view.camera(Store.state.cameraDetail.deviceID)
        showPosition: false
        transformationMode: Qt.SmoothTransformation
    }

    ColumnLayout {
        anchors {
            top: parent.top
            right: parent.right
            bottom: parent.bottom
            margins: spacing
        }
        spacing: Theme.spacingM

        VCCam.StreamTypeComboBox {
            syncTo: Store.state.cameraDetail.streamType

            // Update state.
            onActivated: A.A.ACameraDetail.setStreamType(currentValue)
        }

        Item { Layout.fillHeight: true }

        RowLayout {
            Item { Layout.fillWidth: true }

            VCB.RoundIconButton {
                id: pauseResume

                highlighted: true
                fontIcon {
                    color: "white"
                    font.pixelSize: Theme.iconSizeL
                    name: "pause"
                }

                onClicked: A.ACamera.pauseStream(Store.state.cameraDetail.deviceID)
            }
        }
    }
}
