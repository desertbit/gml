import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

// CPP
import Backend as B

// QML
import External as Ex

ApplicationWindow {
    id: root

    width: 1920
    height: 1080
    visible: true

    Text {
        id: text

        anchors.centerIn: parent
        text: "nVision"
    }

    Ex.Button {
        anchors {
            top: text.bottom
            topMargin: 8
        }
        
        onClicked: {
            if (!B.Backend.switchLocale(locale.text)) {
                console.log("FAIL")
            } else {
                console.log("SUCCESS")
            }
        }
    }

    Image {
        source: "qrc:/images/app-icon.png"
    }

    TextInput {
        id: locale

        anchors {
            bottom: parent.bottom
        }
        text: "de"
    }
}