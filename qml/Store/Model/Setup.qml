import QtQuick

QtObject {
    property QtObject motorAssignment: QtObject {
        property int callID: 0
        property string cameraID: ""
    }
    property QtObject motorTestDrive: QtObject {
        property int callID: 0
        property string cameraID: ""
        property bool active: false
    }
}
