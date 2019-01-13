import QtQuick 2.11
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4

ApplicationWindow {
    id: window
    width: 1280
    height: 720
    visible: true

    Rectangle {
        id: rect
        anchors.fill: parent
        color: "red"
    }

    Button {
        id: button
        text: "Trigger Signal"
        font.pixelSize: 100
        Layout.topMargin: 100
        Layout.alignment: Qt.AlignHCenter
        onClicked: bridge.hello()
    }

    Connections {
        target: bridge
        onConnected: function(i, j) {
            console.log(i, j)
            rect.color = "blue"
        }
    }
}

