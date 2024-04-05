import QtQuick

import Lib as L

QtObject {
    property int state: L.State.Initializing
    property real stateProgress: 0 // -1, if indeterminate
    property QtObject stateRun: QtObject {
        property int productID: 0
        property string productName: ""
        property int runID: 0
        property string runName: ""
        property int numErrors: 0
        property int numDefects: 0
        property int numMeasureDrifts: 0
    }
    property QtObject stateTrain: QtObject {
        property string name: ""
        property string description: ""
        property date created: new Date()
        property bool retrain: false
        property bool recollectingImages: false
        property int sensitivityPreset: 0
        property int customSensitivity: 0
        property real customSensitivityDiameterMin: 0
        property bool cameraSetup: false
    }
    property QtObject stateErr: QtObject {
        property int code: L.State.ErrCode.NoError
        property string msg: ""
        property int state: L.State.Initializing
        property string name: ""
    }
    property QtObject stateClassify: QtObject {
        property int productID: 0
        property string productName: ""
        property int numRuns: 0
    }

    property string devType: ""
    property bool hasMotorizedFocus: false
    property QtObject speedLimit: QtObject  {
        property int min: 0
        property int max: 0
    }
    property string nlineVersion: ""
    property string backendVersion: ""
    property string backendBuildVersion: ""

    property QtObject info: QtObject {
        property string hostname: ""
        property QtObject kernel: QtObject {
            property string version: ""
            property string arch: ""
        }
        property QtObject cpu: QtObject {
            property string model: ""
            property int physCores: 0
            property int logCores: 0
            property string cacheSize: ""
        }
        property QtObject gpu: QtObject {
            property string driverVersion: ""
            property string cudaVersion: ""
            // Contains Model.GPU objects.
            property var devices: []
        }
        property string totalMemory: ""
        property string totalStorage: ""
        property int numDisks: 0
    }

    property QtObject stats: QtObject {
        property int callID: 0

        property string upTime: ""
        property QtObject cpu: QtObject {
            // Contains an integer per core.
            property var usagePerLogCore: []
        }
        // Contains Model.GPUStat objects (without temps).
        property var gpus: []
        property QtObject mem: QtObject {
            property string available: ""
            property string used: ""
            property real usedPct: 0
        }
        // Contains Model.DiskStat objects.
        property var disks: []

        // Contains the temperature readings of both CPU and GPUs.
        // Per element, an object with a "label" and "readings" property exists.
        // The readings property contains the last X temperatures in degree celcius, along with the timestamp.
        property QtObject temps: QtObject {
            property var readings: []
            property int maxReadings: 10
        }
    }

    // Contains Model.StorageDevice objects.
    property var storageDevices: []

    // Contains Model.StorageDeviceFiles objects.
    property var storageDevicesFiles: []
}
