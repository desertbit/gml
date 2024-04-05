import QtQuick

import Lib as L

Event {
    property bool hasNext: false
    property int nextID: 0
    property bool hasPrev: false
    property int prevID: 0
    property bool skippedOverview: false

    property QtObject filter: QtObject {
        property date afterTS: L.LDate.Invalid
        property date beforeTS: L.LDate.Invalid
        property var eventCodes: L.Event.Codes
        property var anomalyClassIDs: null // Array of integers.
    }
}