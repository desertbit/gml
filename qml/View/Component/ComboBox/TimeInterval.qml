import QtQuick

import "." // Use our ComboBox.

// This Component offers a ComboBox to select a time range for the Charts.
ComboBox {
    id: root

    required property int stateTimeInterval
    required property var stateTimeIntervals

    textRole: "text"
    valueRole: "value"
    model: stateTimeIntervals.map(interval => { return { text: _.trInterval(interval), value: interval } })

    // Keep in sync with store.
    onStateTimeIntervalChanged: setCurrentValue(stateTimeInterval)
    onModelChanged: setCurrentValue(stateTimeInterval)

    Component.onCompleted: setCurrentValue(stateTimeInterval)

    QtObject {
        id: _

        function trInterval(interval) {
            switch (interval) {
            case 1:        return qsTr("1 second")
            case 5:        return qsTr("%L1 seconds").arg(5)
            case 15:       return qsTr("%L1 seconds").arg(15)
            case 30:       return qsTr("%L1 seconds").arg(30)
            case 60:       return qsTr("1 minute")
            case 60*5:     return qsTr("%L1 minutes").arg(5)
            case 60*15:    return qsTr("%L1 minutes").arg(15)
            case 60*60:    return qsTr("1 hour")
            case 60*60*12: return qsTr("%L1 hours").arg(12)
            case 60*60*24: return qsTr("%L1 hours").arg(24)
            default:       return `MISSING_TR(${interval})`
            }
        }
    }
}
