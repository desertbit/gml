import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts


import Store
import Theme

import View.Component.Button as VCB
import View.Component.ComboBox as VCCombo

Row {
    readonly property alias currentName: saveLoc.currentValue
    readonly property string currentDeviceID: saveLoc.currentIndex !== -1 && saveLoc.model.length > 0 ? saveLoc.model[saveLoc.currentIndex].deviceID : ""

    spacing: Theme.spacingXS

    VCCombo.ComboBox {
        id: saveLoc

        textRole: "name"
        valueRole: "name"
        model: Store.state.nline.storageDevicesFiles
    }

    VCB.RefreshButton {
        fontIcon.size: Theme.iconSizeS
        flat: true

        onTriggered: A.AGlobal.loadStorageDevicesFiles()
    }
}
