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

    //: The title of the overview page to adjust the focus on all cameras.
    title: Store.state.cameraFocus.editingProduct ? qsTr("Edit camera settings") : qsTr("Cameras settings")

    QtObject {
        id: _

        readonly property var camera: Store.view.camera(Store.state.cameraFocus.activeCameraID)
    }

    ColumnLayout {
        anchors {
            fill: parent
            margins: Theme.spacingS
        }
        spacing: Theme.spacingXS

        // Focused camera.
        VCCam.Camera {
            id: focusedCam

            modelData: _.camera
            interactive: false
            showPause: true
            showFocusPosBar: true

            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        // Footer
        RowLayout {
            spacing: Theme.spacingXS

            Layout.maximumHeight: 150

            // Small Cameras.
            RowLayout {
                id: camerasRow

                spacing: 2

                // This fixes a bug where the container has width 0, even after the repeater has
                // instantiated and layed out its items.
                Layout.minimumWidth: 1
                Layout.minimumHeight: 1

                Repeater {
                    model: Store.state.cameras

                    VCCam.Camera {
                        interactive: true
                        showBusyTag: false

                        Layout.fillHeight: true
                        Layout.maximumWidth: 260

                        onClicked: A.ACameraFocus.selectCamera(modelData.deviceID)

                        Rectangle {
                            anchors {
                                fill: parent
                            }
                            border {
                                width: 3
                                color: "red"
                            }
                            color: "transparent"
                            visible: parent.modelData.deviceID === Store.state.cameraFocus.activeCameraID
                        }
                    }
                }
            }

            VCCam.FocusControl {
                camera: _.camera
                enabled: Store.state.nline.state !== L.State.Setup

                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            VCB.Button {
                text: qsTr("Save to product")
                highlighted: true
                state: "medium"
                visible: Store.state.cameraFocus.editingProduct

                Layout.alignment: Qt.AlignBottom

                onClicked: A.ACameraFocus.saveToProduct(Store.state.cameraFocus.productID)
            }
        }
    }
}
