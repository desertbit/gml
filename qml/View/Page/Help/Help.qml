import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

import Action as A
import Lib as L
import Theme
import Store

import View.Component.Button as VCB
import View.Component.Camera as VCCam
import View.Component.Container as VCC
import View.Component.Device as VCDev
import View.Component.Icon as VCI
import View.Component.Text as VCT

import "Component"

VCC.Page {
    id: root

    title: qsTr("Help")

    // Unfortunately we currently can not move this dialog into the App middleware, since it triggers
    // actions itself and is therefore not suited for the action interception we do inside App.
    VCDev.StorageDeviceDialog {
        id: dialog

        // A callback that will be executed when the user has accepted the dialog.
        // It receives the selected storageDeviceID as single argument.
        property var _cb

        function show(cb) {
            _cb = cb
            open()
        }

        anchors.centerIn: parent
        title: qsTr("Please choose a storage device to save the file to.")
        modal: true

        onSelected: storageDeviceID => _cb(storageDeviceID)
    }

    Flow {
        id: content

        anchors {
            fill: parent
            margins: content.spacing
        }
        spacing: Theme.spacingS

        ManualPane {
            onSaveToStorage: dialog.show(storageDeviceID => A.AHelpResource.saveToStorage(L.Con.Resource.Manual, Store.state.locale, storageDeviceID))
        }

        QuickStartPane {
            // TODO: make visible once guide is available.
            visible: false
        }

        NVisionPane {
            onSaveToStorage: os => dialog.show(storageDeviceID => A.AHelpNVision.saveToStorage(os, storageDeviceID))
        }
    }
}
