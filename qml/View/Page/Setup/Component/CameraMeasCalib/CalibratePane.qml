import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action.SetupCameraMeasCalib as ASetupCameraMeasCalib

import Store
import Theme

import View.Component.Button as VCB
import View.Component.Container as VCC
import View.Component.Form as VCF

VCC.IconPane {
    id: root

    titleText: qsTr("Calibration")
    title.font.pixelSize: Theme.fontSizeL
    enabled: !Store.state.setupCameraMeasCalib.preview.active

    QtObject {
        id: _
        
        readonly property var camera: Store.view.camera(Store.state.setupCameraMeasCalib.cameraID)
    }

    RowLayout {
        spacing: Theme.spacingS

        VCB.Button {
            text: qsTr("Reset")
            enabled: _.camera.isMeasurementCalibrated

            onClicked: ASetupCameraMeasCalib.reset(Store.state.setupCameraMeasCalib.cameraID)
        }

        VCB.Button {
            text: qsTr("Calibrate")
            highlighted: true
            enabled: _.camera.measCalibImagesCount > 0

            onClicked: ASetupCameraMeasCalib.calibrate(Store.state.setupCameraMeasCalib.cameraID)
        }
    }
}