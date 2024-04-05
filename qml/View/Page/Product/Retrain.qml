import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action.CameraDetail as ACameraDetail
import Action.CameraFocus as ACameraFocus
import Action.ProductRetrain as AProductRetrain

import Lib as L
import Store
import Theme

import View.Component.Button as VCB
import View.Component.Camera as VCCam
import View.Component.Container as VCC
import View.Component.Dialog as VCD
import View.Component.Form as VCF
import View.Component.Text as VCT

VCC.Page {
    id: root

    title: qsTr("Retrain")

    states: [
        State {
            name: "majorUpdate"
            when: _.product.isMajorUpdate
            PropertyChanges { target: majorUpdateInfo; visible: true }
            PropertyChanges { target: recollectImages; checked: true; enabled: false }
        }
    ]

    QtObject {
        id: _

        readonly property var product: Store.view.product(Store.state.productRetrain.productID)
    }

    VCD.TrDialog {
        id: confirmDialog

        anchors.centerIn: parent
        title: qsTr("Start Training")
        modal: true
        standardButtons: Dialog.Ok | Dialog.Cancel

        onAccepted: AProductRetrain.start(Store.state.productRetrain.productID, !manualCamSetup.checked, true)

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
            contentSpacing: Theme.spacingM

            Layout.alignment: Qt.AlignTop
            Layout.preferredWidth: 500

            RowLayout {
                spacing: Theme.spacingL

                Layout.maximumHeight: 100

                VCF.LabeledColumnLayout {
                    labelText: qsTr("Name")

                    Text {
                        font {
                            pixelSize: Theme.fontSizeM
                        }
                        text: _.product.name
                    }
                }

                VCF.LabeledColumnLayout {
                    labelText: qsTr("Description")

                    Text {
                        font {
                            pixelSize: Theme.fontSizeM
                        }
                        text: _.product.description || "---"
                        wrapMode: Text.WordWrap
                        elide: Text.ElideRight

                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }
                }
            }

            RowLayout {
                spacing: Theme.spacingL

                VCF.LabeledColumnLayout {
                    labelText: qsTr("Current version")

                    Text {
                        font {
                            pixelSize: Theme.fontSizeM
                        }
                        text: _.product.backendVersion
                    }
                }

                VCF.LabeledColumnLayout {
                    labelText: qsTr("New version")

                    Text {
                        font {
                            pixelSize: Theme.fontSizeM
                        }
                        text: Store.state.nline.backendVersion
                    }
                }
            }

            VCT.Info {
                id: majorUpdateInfo

                //: The update of an AI model.
                text: qsTr("This update requires to collect new images")
                visible: false

                Layout.bottomMargin: Theme.spacingS
            }

            ColumnLayout {
                spacing: -Theme.spacingS

                CheckBox {
                    id: recollectImages

                    text: qsTr("Recollect images")
                    font.pixelSize: Theme.fontSizeL

                    Layout.fillWidth: true
                }

                CheckBox {
                    id: manualCamSetup

                    text: qsTr("Manual camera setup")
                    font.pixelSize: Theme.fontSizeL
                    visible: Store.state.nline.hasMotorizedFocus
                    enabled: recollectImages.checked
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
                    visible: recollectImages.checked

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

                text: qsTr("Retrain")
                highlighted: true
                state: "large"

                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: Theme.spacingS

                onClicked: {
                    if (recollectImages.checked) {
                        confirmDialog.open()
                    } else {
                        AProductRetrain.start(Store.state.productRetrain.productID, !manualCamSetup.checked, false)
                    }
                }
            }
        }

        Item { Layout.fillWidth: true } // Filler
    }
}
