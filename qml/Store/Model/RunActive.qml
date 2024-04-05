import QtQuick

import Lib as L

Run {
    // Contains Model.RunPause objects.
    property var pauses: []
    property QtObject product: QtObject {
        property int id: 0
        property string name: ""
        property string description: ""
    }
    property QtObject stats: QtObject {
        property int callID: 0
        property int err: L.Con.RunErr.NoErr
        property int alarm: L.Con.AlarmCode.Ok
        property int infFPS: 0
        property real minDiameter: 0
        property real maxDiameter: 0
        property QtObject speed: QtObject {
            property int current: 0
            property real avg: 0
            property int min: 0
            property int max: 0
        }
        property QtObject position: QtObject {
            property int current: 0
        }
    }
    property QtObject events: QtObject {
        property int callID: 0
        // Contains Model.Event objects.
        property var model: []
        property int max: L.Con.MaxActiveRunLiveEvents
    }
    property QtObject aggrEvents: QtObject {
        property int callID: 0
        // Contains Model.AggrEvent objects.
        property var changes: []
    }
    property QtObject eventDistribution: QtObject {
        property int callID: 0
        // Contains { eventCode: count } objects.
        property var model: ({})
    }
    property QtObject aggrMeasurePoints: QtObject {
        property int callID: 0
        // Contains Model.AggrMeasurePoint objects.
        property var model: []
    }
    property int maxGraphPoints: 60

    property QtObject filter: QtObject {
        property var eventCodes: L.Event.Codes
        property int timeRange: 300 // Seconds
        property int timeInterval: 5 // Seconds

        // Contains integers (seconds).
        property var timeIntervals: L.TimeI.model(timeRange)
    }
}
