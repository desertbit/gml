import QtQuick

import Lib as L

QtObject {
    property int id: 0
    property int productID: 0
    property date created: L.LDate.Invalid
    property int eventID: 0 // Is 0, if event no longer exists.
    // Contains Model.AnomalyBox objects.
    property var anomalyBoxes: []

    property string imageSource: ""
    property string imageDefectSource: ""

    // If true, there is a classification image available after this one.
    property bool hasNext: false
    property int nextID: 0
    // If true, there is a classification image available before this one.
    property bool hasPrev: false
    property int prevID: 0

    // If true, the user navigated to the image via its event.
    property bool fromEvent: false
}