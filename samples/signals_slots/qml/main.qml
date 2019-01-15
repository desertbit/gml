import QtQuick 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4

ApplicationWindow {
    id: window

    function dp(pixel) { return pixel * dip }

    width: 1280
    height: 720
    visible: true

    Rectangle {
        id: rect
        anchors.fill: parent
        color: "red"
    }

	Text {
		text: bridge.state
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.verticalCenter: parent.verticalCenter
		font.pointSize: 24
		font.bold: true
	}
    
    Button {
        id: button
        anchors {
            top: parent.top
            left: parent.left
        }
        width: 250
        height: 50
        text: "Trigger Signal"
        font.pixelSize: 38
        onClicked: function() {
            console.log(bridge.clicked(1, "Hallo"))
            b2.connect()
        }
    }

    Image {
        width: 500
        height: 100
        //source: "image://imgprov/test/15"
        sourceSize.width: 100
        sourceSize.height: 100
        fillMode: Image.PreserveAspectFit
    }

    ListView {
        id: list
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
        width: 200
        model: modl
        delegate: Item {
            property var item : JSON.parse(display)

            width: list.width
            height: 30
            Text {
                color: "green"
                text: item.text
            }

            Text {
                color: "blue"
                text: item.row
            }
        }
    }

    Connections {
        target: bridge
        onGreet: function(i1, i2, i3, s, r, b, bb, sb) {
            console.log(i1, i2, i3, s, r, b, bb, sb)
            rect.color = "blue"
        }
    }
}

