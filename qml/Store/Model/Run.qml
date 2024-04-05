import QtQuick

import Lib as L

QtObject {
    property int id: 0
    property string name: ""
    property date created: new Date()
    property date finished: L.LDate.Invalid
    property int productID: 0
    property int numEvents: 0
    property int sensitivityPreset: 0
    property int customSensitivity: 0
    property real customSensitivityDiameterMin: 0
    property string backendVersion: ""
    property bool enableMeasurement: false
    property real diameterNorm: 0
    property real diameterUpperDeviation: 0
    property real diameterLowerDeviation: 0
    property real measurementWidth: 0
    property real avgSpeed: 0
    property int minSpeed: 0
    property int maxSpeed: 0
    property int length: 0
    property int errCode: 0
    property string errMsg: ""
    property bool classificationDirty: false
    property bool isFinished: false
    property bool hasFailed: false
    property int duration: 0
}
