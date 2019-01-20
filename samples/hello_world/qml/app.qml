import QtQuick 2.11
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4

ApplicationWindow {
    id: window
    width: 300
    height: 300
    visible: true

	Text {
		text: "Hello world!"
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.verticalCenter: parent.verticalCenter
		font.pointSize: 24
		font.bold: true
	}
}