import QtQuick

QtObject {
    property int id: 0
    property string name: ""
    property string description: ""
    property date created: new Date()
    property date updated: new Date()
    property date lastTrained: new Date()
    property int sensitivityPreset: 0
    property int customSensitivity: 0
    property real customSensitivityDiameterMin: 0
    property int defaultSpeed: 0
    property string backendVersion: ""
    property bool enableMeasurement: false
    property real diameterNorm: 0
    property real diameterUpperDeviation: 0
    property real diameterLowerDeviation: 0
    property real measurementWidth: 0
    property bool isMajorUpdate: false
    property bool updateRequired: false
    property bool updateAvailable: false
    property int numTrainImages: 0
    property int numCustomTrainImages: 0
    property int numRuns: 0
    // Contains Model.Run objects.
    property var recentRuns: []
    property bool hasRunWithDirtyClassification: false
    // Contains integers.
    property var recentRunsNumEvents: []
    property date recentRunsNumEventsOldestTS: new Date()
    property date recentRunsNumEventsNewestTS: new Date()
    property string thumbnailSource: ""
}
