import QtQuick

QtObject {
    property QtObject kunbus: QtObject {
        property int callID: 0

        property QtObject input: QtObject {
            property QtObject system: QtObject {
                property bool enabled: false
                property bool direction: false
                property bool resetError: false
                property bool resetTriggerError: false
                property int samplingRate: 0
            }
            property QtObject run: QtObject {
                property bool startStop: false
                property bool pauseResume: false
                property bool livePosition: false
                property string productID: ""
                property string runID: ""
                property int speed: 0
                property int position: 0
            }
            property QtObject trainProduct: QtObject {
                property bool startStop: false
            }
        }
        property QtObject output: QtObject {
            property QtObject system: QtObject {
                property bool status: false
                property int apiVersion: 0
                property int state: 0
                property int error: 0
                property int triggerError: 0
                property int progress: 0
            }
            property QtObject run: QtObject {
                property bool errorFlag: false
                property bool defectFlag: false
                property bool measureDriftFlag: false
                property int numErrors: 0
                property int numDefects: 0
                property int numMeasureDrifts: 0
            }
        }
    }
}
