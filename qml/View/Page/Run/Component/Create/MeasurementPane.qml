import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import Action as A
import Lib as L
import Store
import Theme

import View.Component.Button as VCB
import View.Component.Container as VCC
import View.Component.Form as VCF
import View.Component.Image as VCI
import View.Component.Measurement as VCM

VCC.TickIconPane {
    id: root

    property alias enableMeasurement: ctrl.enableMeasurement
    property alias diameterNorm: ctrl.diameterNorm
    property alias diameterUpperDeviation: ctrl.diameterUpperDeviation
    property alias diameterLowerDeviation: ctrl.diameterLowerDeviation
    property alias measurementWidth: ctrl.measurementWidth

    signal loadDefaults()

    titleText: "3. " + qsTr("Measurement")

    states: [
        State {
            name: "valid"
            extend: "ticked"
            when: L.Val.measurement(enableMeasurement, diameterNorm, diameterUpperDeviation, diameterLowerDeviation, measurementWidth)
        }
    ]

    VCM.Control {
        id: ctrl
    }

    VCB.Button {
        text: qsTr("Load defaults")
        
        onClicked: root.loadDefaults()
    }
}
