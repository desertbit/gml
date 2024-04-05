import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Theme

// This dialog is only used in the App middleware.
TrDialog {
    id: root

    // Emitted when the user clicks the delete button.
    signal deleted(string type, var data)

    // Emitted when the user clicks the cancel button or otherwise
    // closes the dialog without confirmation.
    signal canceled()

    // Shows a dialog to delete a single item.s
    // Args:
    //  - type(string) : The action type
    //  - data(object) : The action data
    //  - name(string) : The name of the item to delete
    function show(type, data, name) {
        _.name = name
        _.type = type
        _.data = data
        open()
    }

    anchors.centerIn: parent
    standardButtons: Dialog.Yes | Dialog.Cancel
    title: qsTr("Delete %1").arg(_.name)
    modal: true

    onAccepted: root.deleted(_.type, _.data)
    onRejected: root.canceled()

    QtObject {
        id: _

        property string type: ""
        property var data: ({})
        property string name: ""
    }

    ColumnLayout {
        anchors.fill: parent

        Text {
            font.pixelSize: Theme.fontSizeL
            text: qsTr("Are you sure you want to delete %1?\nThis action can not be undone.").arg(_.name)
            wrapMode: Text.WordWrap
        }
    }
}
