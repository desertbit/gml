import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action.SetupCameraMeasCalibGallery as ASetupCameraMeasCalibGallery

import Store
import Theme

import View.Component.Button as VCB
import View.Component.Container as VCC
import View.Component.Form as VCF

VCC.IconPane {
    id: root

    titleText: qsTr("Gallery")
    title.font.pixelSize: Theme.fontSizeL

    QtObject {
        id: _
        
        readonly property var camera: Store.view.camera(Store.state.setupCameraMeasCalib.cameraID)
    }

    RowLayout {
        spacing: Theme.spacingS

        Text {
            color: enabled ? Theme.colorForeground : Theme.colorForegroundTier3
            text: qsTr("Number of images: %L1").arg(_.camera.measCalibImagesCount)
            font.pixelSize: Theme.fontSizeM
            wrapMode: Text.WordWrap

            Layout.fillWidth: true
        }

        VCB.Button {
            text: qsTr("View")

            onClicked: ASetupCameraMeasCalibGallery.view(Store.state.setupCameraMeasCalib.cameraID)
        }
    }
}