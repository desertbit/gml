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

    // Shows the dialog to delete multiple items.
    // Args:
    //  - type(string)    : The action type
    //  - data(object)    : The action data
    //  - title(string)   : The title of the dialog
    //  - message(string) : The message of the dialog
    function show(type, data, title, message) {
        _.type = type
        _.data = data
        root.title = title
        msg.text = message
        open()
    }

    anchors.centerIn: parent
    standardButtons: Dialog.Yes | Dialog.Cancel
    modal: true

    onAccepted: root.deleted(_.type, _.data)
    onRejected: root.canceled()

    QtObject {
        id: _

        property string type: ""
        property var data: ({})
    }

    ColumnLayout {
        anchors.fill: parent

        Text {
            id: msg

            font.pixelSize: Theme.fontSizeL
            wrapMode: Text.WordWrap

            Layout.fillWidth: true
        }
    }
}
