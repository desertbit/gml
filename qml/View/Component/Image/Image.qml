import QtQuick as Q
import QtQuick.Controls
import QtQuick.Controls.Material

import Theme

Q.Image {
    id: root

    // True, if no image has been loaded.
    readonly property alias empty: background.visible
    // The color of the alternate background.
    property alias altBackground: background.color
    property alias background: background
    // If true, the loading animation is shown.
    // Useful, if the resource loading happens elsewhere.
    property bool loading: false
    // The placeholder image.
    property alias placeholder: placeholder

    fillMode: Image.PreserveAspectFit

    Q.Rectangle {
        id: background

        color: "#AAAAAA"
        anchors.fill: parent
        visible: root.status === Image.Error
    }

    Q.Image {
        id: placeholder

        anchors {
            margins: Theme.spacingS
            fill: parent
        }
        fillMode: Image.PreserveAspectFit
        source: "qrc:/resources/images/placeholder"
        smooth: false
        visible: background.visible
    }

    BusyIndicator {
        anchors.centerIn: parent
        running: root.status === Image.Loading || root.loading
    }
}
