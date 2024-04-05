import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Store

// Camera column.
ColumnLayout {
    id: root

    // Emitted when the user has clicked on a camera stream.
    signal cameraClicked(string deviceID)

    implicitWidth: children.length ? children[0].implicitWidth : 0
    spacing: 2

    // This fixes a bug where the container has width 0, even after the repeater has
    // instantiated and layed out its items.
    Layout.minimumWidth: 1

    Repeater {
        model: Store.state.cameras

        Camera {
            Layout.maximumWidth: 600
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignHCenter

            onClicked: root.cameraClicked(modelData.deviceID)
        }
    }
}
