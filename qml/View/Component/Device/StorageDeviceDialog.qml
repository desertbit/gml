import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Store
import Theme

import View.Component.Dialog as VCD

VCD.TrDialog {
    id: root

    default property alias children: content.children

    // Emitted when the user has selected a storage device.
    signal selected(string storageDeviceID)

    standardButtons: Store.state.nline.storageDevices.empty() ? Dialog.Cancel : (Dialog.Ok | Dialog.Cancel)

    onAccepted: root.selected(storageDevice.currentID)

    ColumnLayout {
        id: content

        anchors.fill: parent

        Text {
            text: qsTr("Choose the storage location:")
            wrapMode: Text.WordWrap
            horizontalAlignment: Qt.AlignHCenter

            Layout.fillWidth: true
        }

        StorageDeviceSelector {
            id: storageDevice

            Layout.alignment: Qt.AlignHCenter
        }
    }
}
