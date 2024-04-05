import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action.Global as AGlobal

import Store
import Theme

import View.Component.Button as VCB
import View.Component.ComboBox as VCCombo

Row {
    property alias currentID: saveLoc.currentValue

    spacing: Theme.spacingXS

    VCCombo.ComboBox {
        id: saveLoc

        textRole: "label"
        valueRole: "id"
        model: Store.state.nline.storageDevices
    }

    VCB.RefreshButton {
        fontIcon.size: Theme.iconSizeS
        flat: true

        onTriggered: AGlobal.loadStorageDevices()
    }
}
