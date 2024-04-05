import QtQuick

import Lib as L

QtObject {
    property int productID: 0
    property int runID: 0
    property int viewState: L.Con.EventOverviewState.List

    property QtObject list: QtObject {
        // Contains Model.Event objects.
        property var page: []
        property int totalCount: 0
        property int filteredCount: 0
        property Cursor cursor: Cursor {}
        property int limit: 0
    }

    property QtObject chart: QtObject {
        // Contains Model.AggrEvent objects.
        property var points: []
    }

    property QtObject distribution: QtObject {
        // Contains { eventCode: count } objects.
        property var model: ({})
    }

    property QtObject measurement: QtObject {
        // Contains Model.AggrMeasurePoint objects.
        property var points: []
        property bool enabled: false
        property real diameterNorm: 0
        property real diameterMin: 0
        property real diameterMax: 0
    }

    property QtObject filter: QtObject {
        property date afterTS: L.LDate.Invalid
        property date beforeTS: L.LDate.Invalid
        property var eventCodes: L.Event.Codes
        property var anomalyClassIDs: null // Array of integers.

        // Contains integers (seconds).
        property var timeIntervals: []
        property int timeInterval: 5 // Seconds

        // Boundaries for ts filter.
        property date minTS: L.LDate.Min
        property date maxTS: L.LDate.Max
        property int timeRange: 0
    }

    // If true, the user skipped the RunOverview page.
    property bool skippedRunOverview: false
    // If true, the user skipped the RunDetail page.
    property bool skippedRunDetail: false
    property string skippedRunName: ""
}
