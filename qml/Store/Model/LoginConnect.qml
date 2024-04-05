import QtQuick

QtObject {
    property string addr: ""
    property int callID: 0
    property int secondsUntilRetry: 0
    property string err: ""
    // Dedicated error flags.
    property bool initializing: false
    property bool connectionRefused: false
}
