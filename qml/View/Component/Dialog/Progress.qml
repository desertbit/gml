import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action.Int as AInt

import Theme

TrDialog {
    property alias text: msg.text
    property string type: ""

    modal: true
    standardButtons: Dialog.Cancel

    onAboutToShow: bar.value = 0
    // Abort the operation.
    onRejected: AInt.emitCancel(type)

    ColumnLayout {
        anchors.fill: parent

        Text {
            id: msg

            font.pixelSize: Theme.fontSizeL
        }

        ProgressBar {
            id: bar

            Layout.preferredWidth: 500
        }
    }
}
