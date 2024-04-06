import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action as A
import Lib as L
import Store
import Theme

import View.Component.Camera as VCCam
import View.Component.ComboBox as VCCombo
import View.Component.Container as VCC
import View.Component.Form as VCF

VCC.IconPane {
    id: root

    titleText: qsTr("Cameras")
    titleIconName: "aperture"
    titleIconColor: Material.color(Material.Lime)
    contentSpacing: Theme.spacingS

    VCF.LabeledColumnLayout {
        labelText: qsTr("Autofocus")
        visible: Store.state.nline.hasMotorizedFocus

        Text {
            text: qsTr("Perform an Autofocus on all cameras when starting a new batch.")
            font.pixelSize: Theme.fontSizeM
            wrapMode: Text.WordWrap

            Layout.fillWidth: true
        }

        Switch {
            checked: Store.state.settings.autofocusBeforeStartRun
            text: checked ? qsTr("On") : qsTr("Off")
            font.pixelSize: Theme.fontSizeL
            topPadding: 0
            bottomPadding: 0

            Layout.alignment: Qt.AlignRight

            onToggled: A.ASettings.setAutofocusBeforeStartRun(checked)
        }
    }

    VCF.LabeledColumnLayout {
        //: A camera image being mirrored either horizontally, vertically or both.
        labelText: qsTr("Mirroring")

        VCCombo.ComboBox {
            id: flipState

            function _elem(flip) {
                return { text: L.Tr.flip(flip), value: flip }
            }

            syncTo: Store.state.settings.camerasFlipState
            textRole: "text"
            valueRole: "value"
            model: [
                _elem(L.Con.Flip.None),
                _elem(L.Con.Flip.X),
                _elem(L.Con.Flip.Y),
                _elem(L.Con.Flip.Both)
            ]

            onActivated: A.ASettings.setCamerasFlipState(currentValue)
        }
    }

    VCCam.Cameras {
        id: cameras

        Layout.alignment: Qt.AlignHCenter

        onCameraClicked: deviceID => A.ACameraDetail.view(deviceID, L.Con.StreamType.Raw)
    }
}
