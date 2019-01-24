import QtQuick 2.11
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4

ApplicationWindow {
    id: window
    width: 300
    height: 300
    visible: true

	ListView {
	    anchors.fill: parent
	    delegate: Text {
	        color: "red"
	        text: display
            font.pointSize: 24
		    font.bold: true
	    }
	    model: m
	    Component.onCompleted: console.log(m.get(5))
	}
}