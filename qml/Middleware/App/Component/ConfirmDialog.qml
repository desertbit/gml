import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs as QD
import Qt.labs.settings

import Lib as L
import Theme

import View.Component.Dialog as VCD

VCD.TrDialog {
    id: root

    // Emitted when the user confirmed the action.
    signal confirmed(string type, var data)
    // Emitted when the user denied the action.
    signal denied()

    // Shows the confirmation dialog for the given action.
    // Args:
    //  - type(string)  : The action type
    //  - data(object)  : The action data
    //  - title(string) : The title of the dialog
    //  - text(string)  : The message of the dialog
    function show(type, data, title, text) {
        _.type = type
        _.data = data
        root.title = title
        message.text = text
        open()
    }

    standardButtons: Dialog.Yes | Dialog.Cancel
    dim: true
    contentWidth: parent.width / 3
    contentHeight: message.implicitHeight

    onAccepted: confirmed(_.type, _.data)
    onRejected: denied()

    QtObject {
        id: _

        property string type: ""
        property var data: ({})
    }

    Text {
        id: message

        anchors.fill: parent
        font.pixelSize: Theme.fontSizeL
        wrapMode: Text.WordWrap
        width: parent.contentWidth
    }
}