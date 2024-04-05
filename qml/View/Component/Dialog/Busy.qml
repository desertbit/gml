import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts


import Theme

TrDialog {
    id: root

    property alias text: msg.text

    modal: true
    closePolicy: Popup.NoAutoClose

    ColumnLayout {
        anchors.fill: parent
        spacing: Theme.spacingM

        BusyIndicator {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 60
            Layout.preferredHeight: width
        }

        Text {
            id: msg

            font.pixelSize: Theme.fontSizeL
            wrapMode: Text.WordWrap
            text: "dummy"

            Layout.preferredWidth: 500
            Layout.maximumWidth: 500
        }
    }
}
