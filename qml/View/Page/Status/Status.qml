import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

import Action as A
import Lib as L
import Theme
import Store

import View.Component.Button as VCB
import View.Component.Camera as VCCam
import View.Component.Container as VCC
import View.Component.Icon as VCI
import View.Component.Text as VCT

import "Component"

VCC.Page {
    id: root

    title: qsTr("Status")

    RowLayout {
        anchors {
            fill: parent
            margins: Theme.spacingS
        }
        spacing: Theme.spacingS

        // Camera column.
        VCCam.Cameras {
            onCameraClicked: deviceID => A.A.ACameraDetail.view(deviceID, Store.state.status.streamType)

            VCCam.StreamTypeComboBox {
                id: streamTypeComboBox

                topInset: 0
                bottomInset: 0
                topPadding: 0
                bottomPadding: 0
                syncTo: Store.state.status.streamType

                Layout.alignment: Qt.AlignRight

                // Update state.
                onActivated: A.AStatus.setStreamType(currentValue)
            }
        }

        RowLayout {
            spacing: Theme.spacingM

            Layout.alignment: Qt.AlignTop

            StatePane {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            VCC.WidestItemColumnLayout {
                spacing: Theme.spacingS

                Layout.alignment: Qt.AlignTop

                VCB.ActionButton {
                    icon.source: "qrc:/resources/icons/spool_new.svg"
                    text: qsTr("New\nbatch")
                    fontColor: Theme.colorOnRun
                    backgroundColor: Theme.colorRunTier2

                    onClicked: A.ARunCreate.view()
                }

                VCB.ActionButton {
                    icon.source: "qrc:/resources/icons/spool_recent.svg"
                    text: qsTr("Latest\nbatches")
                    fontColor: "white"
                    backgroundColor: Theme.colorRun

                    onClicked: A.ARunRecentOverview.view()
                }

                VCB.ActionButton {
                    icon.source: "qrc:/resources/icons/product_add.svg"
                    text: qsTr("New\nproduct")
                    fontColor: Theme.colorOnSettings
                    backgroundColor: Theme.colorProductTier2

                    onClicked: A.AProductCreate.view()
                }

                VCB.ActionButton {
                    icon.source: "qrc:/resources/icons/product.svg"
                    text: qsTr("Products")
                    fontColor: Theme.colorOnProduct
                    backgroundColor: Theme.colorProduct

                    onClicked: A.AProductOverview.view()
                }

                VCB.ActionButton {
                    icon.source: "qrc:/resources/icons/anomaly_class.svg"
                    //: This is the button to show the page of anomaly classes.
                    text: qsTr("Anomaly\nclasses")
                    fontColor: Theme.colorOnAnomalyClass
                    backgroundColor: Theme.colorAnomalyClass

                    onClicked: A.AAnomalyClass.view()
                }

                VCB.ActionButton {
                    icon.source: "qrc:/resources/icons/health_metrics.svg"
                    text: qsTr("Dashboard")
                    fontColor: Theme.colorForeground
                    backgroundColor: Theme.colorBackground

                    onClicked: A.ADashboard.view()
                }

                VCB.ActionButton {
                    icon.source: "qrc:/resources/icons/camera_settings.svg"
                    text: qsTr("Camera\nsettings")
                    fontColor: Theme.colorForeground
                    backgroundColor: Theme.colorBackground
                    visible: Store.state.nline.hasMotorizedFocus

                    onClicked: A.A.ACameraFocus.view()
                }

                VCB.ActionButton {
                    icon.source: "qrc:/resources/icons/center_focus_weak.svg"
                    text: qsTr("Autofocus")
                    fontColor: Theme.colorForeground
                    backgroundColor: Theme.colorBackground
                    visible: Store.state.nline.hasMotorizedFocus
                    enabled: Store.state.nline.state !== L.State.Setup

                    onClicked: A.ACamera.autofocusAll()
                }
            }
        }
    }
}
