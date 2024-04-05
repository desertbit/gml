import QtQuick

import Lib as L

QtObject {
    property int id: 0
    property int runID: 0
    property int productID: 0
    property date ts: L.LDate.Invalid
    property int num: 0
    property int code: 0
    property int errCode: 0
    property int position: 0
    property int resultIndex: 0
    property bool usedAsCustomTrainImage: false
    // Contains M.EventAnomalyBox json data.
    property var anomalyBoxes: []
    // Contains M.EventMeasurePoint json data.
    property var measurePoint: ({ min: { diameter: 0 }, max: { diameter: 0 } })
    property bool classifiable: false
    property bool hasMeasurement: false
    property string thumbnailSource: ""
    property string imageSource: ""
    property string imageDefectSource: ""
    property string imageMeasurementSource: ""
}