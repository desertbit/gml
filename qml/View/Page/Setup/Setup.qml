import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action.AppToast as AAppToast
import Action.Setup as ASetup

import Lib as L
import Store
import Theme

import View.Component.Button as VCB
import View.Component.Camera as VCCam
import View.Component.ComboBox as VCCombo
import View.Component.Container as VCC
import View.Component.Device as VCDev
import View.Component.Form as VCF

import "Component/Setup"

VCC.Page {
    id: root

    title: qsTr("Setup")

    // Unfortunately we currently can not move this dialog into the App middleware, since it triggers
    // actions itself and is therefore not suited for the action interception we do inside App.
    VCDev.StorageDevicesFilesDialog {
        id: storageDevicesFilesDialog

        anchors.centerIn: Overlay.overlay
        title: qsTr("Please choose a file containing the import data.")
        modal: true

        onSelected: (storageDeviceFileName, storageDeviceID) => ASetup.importDataFromStorage(storageDeviceFileName, storageDeviceID)
    }

    // Unfortunately we currently can not move this dialog into the App middleware, since it triggers
    // actions itself and is therefore not suited for the action interception we do inside App.
    VCDev.StorageDeviceDialog {
        id: storageDeviceDialog

        anchors.centerIn: Overlay.overlay
        title: qsTr("Please choose a storage device to save the file to.")
        modal: true

        onSelected: storageDeviceID => {
            if (!storageDeviceSerialNum.acceptableInput) {
                AAppToast.showError(qsTr("Invalid measuring head serial number."))
                return
            }

            ASetup.exportDataToStorage(storageDeviceID, storageDeviceSerialNum.text)
        }

        VCF.LabeledColumnLayout {
            labelText: qsTr("Measuring head serial number")
            label.required: true

            VCF.TextField {
                id: storageDeviceSerialNum

                placeholderText: qsTr("Serial number") + "..."
                // Allow a sequence of digits up to length 12.
                validator: RegularExpressionValidator { regularExpression: /[0-9]{1,12}/ }
                inputMethodHints: Qt.ImhFormattedNumbersOnly

                Layout.fillWidth: true
            }
        }
    }

    RowLayout {
        anchors {
            fill: parent
            margins: Theme.spacingS
        }
        spacing: Theme.spacingXS

        // Camera column.
        ColumnLayout {
            spacing: Theme.spacingXS

            Repeater {
                model: Store.state.cameras

                CameraPanel {
                    Layout.fillHeight: true
                }
            }
        }

        Item { Layout.fillWidth: true } // Filler

        RowLayout {
            spacing: Theme.spacingS

            Layout.alignment: Qt.AlignTop

            VCB.Button {
                text: qsTr("Import")
                state: "medium"

                onClicked: {
                    if (Store.state.app.opts.withStorageDevices) {
                        storageDevicesFilesDialog.open()
                    } else {
                        ASetup.importData()
                    }
                }
            }

            VCB.Button {
                text: qsTr("Export")
                state: "medium"

                onClicked: {
                    if (Store.state.app.opts.withStorageDevices) {
                        storageDeviceDialog.open()
                    } else {
                        ASetup.exportData()
                    }
                }
            }
        }
    }
}
