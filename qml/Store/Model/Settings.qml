import QtQuick

import Lib as L

QtObject {
    property bool autofocusBeforeStartRun: false
    property int camerasFlipState: L.Con.Flip.None
    property bool alertAndPauseEnabled: false
    property var alertAndPauseEventCodes: [L.Event.Code.Defect, L.Event.Code.MeasureDrift]
    property QtObject network: QtObject {
        property int mode: L.Con.NetworkMode.DHCP
        property string addr: ""
        property int subnetPrefixLength: 0
        property string gateway: ""
        property string dns: ""
    }

    // Contains Model.NetworkInterface objects.
    property int networkInterfacesCallID: 0
    property var networkInterfaces: []
}
