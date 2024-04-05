import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action.Setup as ASetup


import View.Component.Button as VCB

Ready {
    id: root

    titleRightContent: [
        VCB.Button {
            state: "medium"
            highlighted: true
            text: qsTr("View setup page")

            onClicked: ASetup.viewFromStatus()
        }
    ]
}