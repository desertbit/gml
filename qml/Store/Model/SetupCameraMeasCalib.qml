import QtQuick

import Lib as L

QtObject {
    property string cameraID: ""
    property int streamType: L.Con.StreamType.Raw

    property QtObject preview: QtObject {
        property bool active: false
        property real diameter: 0
        property int stepPos: 0
        // Contains integers.
        property var pixels: []
    }

    property bool validating: false
}
