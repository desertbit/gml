import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Theme
import Store

// Height must be set externally.
Rectangle {
    id: root

    required property int page

    color: "transparent"
    border {
        color: "black"
        width: 1
    }
    implicitWidth: img.width+(2*border.width)

    Image {
        id: img

        anchors {
            top: parent.top
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            margins: root.border.width
        }
        // A4 aspect ratio (roughly).
        width: height * 0.71
        source: Store.state.pdfPreview.source !== "" ? `file://${Store.state.pdfPreview.source}` : ""
        cache: false
        currentFrame: visible ? root.page : 0
        visible: root.page >= 0
    }
}
