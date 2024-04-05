import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Store
import Theme

import View.Component.Dialog as VCD

VCD.TrDialog {
    id: root

    // Emitted when the user has selected a storage device file.
    signal selected(string storageDeviceFileName, string storageDeviceID)

    standardButtons: Store.state.nline.storageDevicesFiles.empty() ? Dialog.Cancel : (Dialog.Ok | Dialog.Cancel)

    onAccepted: root.selected(selector.currentName, selector.currentDeviceID)

    ColumnLayout {
        anchors.fill: parent

        Text {
            text: qsTr("Choose a file:")
            wrapMode: Text.WordWrap
            horizontalAlignment: Qt.AlignHCenter

            Layout.fillWidth: true
        }

        StorageDevicesFilesSelector {
            id: selector

            Layout.alignment: Qt.AlignHCenter
        }
    }
}
