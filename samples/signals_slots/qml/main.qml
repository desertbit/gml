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
        onClicked: bridge.clicked()
    }

    Image {
        width: 100
        height: 100
        source: "qrc:/resources/menu.png"
    }

    Connections {
        target: bridge
        onGreet: function(i1, i2, i3, s, r, b, bb, sb) {
            console.log(i1, i2, i3, s, r, b, bb, sb)
            rect.color = "blue"
        }
    }
}

