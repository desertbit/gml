import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action.SetupCameraMeasCalib as ASetupCameraMeasCalib

import Lib as L
import Store
import Theme

import View.Component.Button as VCB
import View.Component.Camera as VCCam
import View.Component.Container as VCC

import "Component/CameraMeasCalib"

VCC.Page {
    id: root

    title: qsTr("Measurement calibration - %1").arg(L.Tr.camPosition(_.camera.position))

    states: [
        State {
            name: "preview"
            when: Store.state.setupCameraMeasCalib.preview.active
            PropertyChanges { target: cam; visible: false }
            PropertyChanges { target: preview; visible: true; source: "image://imgprov/setupCameraMeasCalibCapturePreview" }
            PropertyChanges { target: focusCtrl; enabled: false }
        }
    ]

    QtObject {
        id: _
        
        readonly property var camera: Store.view.camera(Store.state.setupCameraMeasCalib.cameraID)
    }

    RowLayout {
        anchors {
            fill: parent
            margins: Theme.spacingS
        }
        spacing: Theme.spacingS

        ColumnLayout {
            spacing: Theme.spacingS

            VCCam.Camera {
                id: cam 

                modelData: _.camera
                interactive: false
                showPause: true
                showFocusPosBar: true

                Layout.fillWidth: true
                Layout.fillHeight: true

                // Draw a grid above the image to help the operator align the calibration bar.
                
                ColumnLayout {
                    anchors.fill: parent
                    spacing: 0

                    Repeater {
                        model: 6

                        Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            Rectangle {
                                anchors {
                                    left: parent.left
                                    right: parent.right
                                    verticalCenter: parent.verticalCenter
                                }
                                color: "white"
                                height: 1
                            }
                        }
                    }
                }

                RowLayout {
                    anchors.fill: parent
                    spacing: 0

                    Repeater {
                        model: 3

                        Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            Rectangle {
                                anchors {
                                    top: parent.top
                                    bottom: parent.bottom
                                    horizontalCenter: parent.horizontalCenter
                                }
                                color: "white"
                                width: 1
                            }
                        }
                    }
                }

                VCCam.StreamTypeComboBox {
                    anchors {
                        top: parent.top
                        right: parent.right
                        margins: Theme.spacingM
                    }
                    syncTo: Store.state.setupCameraMeasCalib.streamType

                    // Update state.
                    onActivated: ASetupCameraMeasCalib.setStreamType(currentValue)
                }
            }

            // Capture preview.
            Image {
                id: preview

                visible: false
                fillMode: Image.PreserveAspectFit
                cache: false

                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            // Focus control pane.
            VCCam.FocusControl {
                id: focusCtrl

                padding: Theme.spacingXS
                camera: _.camera

                Layout.alignment: Qt.AlignHCenter
            }
        }

        // Steps
        ColumnLayout {
            spacing: Theme.spacingS

            Layout.alignment: Qt.AlignTop
            Layout.minimumWidth: 300
            Layout.maximumWidth: 300

            GalleryPane {
                Layout.fillWidth: true
            }

            AddImagePane {
                Layout.fillWidth: true
            }

            CalibratePane {
                Layout.fillWidth: true
            }

            Item { Layout.fillHeight: true } // Filler
        }
    }
}
