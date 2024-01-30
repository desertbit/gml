import QtQuick 2.16
import QtQuick.Controls 2.16
import QtQuick.Controls.Material 2.16
import QtQuick.Layouts 1.16

ApplicationWindow {
    id: root

    width: 1920
    height: 1080
    visible: true

    Text {
        anchors.centerIn: parent
        text: "Hello World"
    }

    Image {
        source: "/nVision/res/app-icon.png"
    }
}