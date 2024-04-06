import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts



import View.Component.Button as VCB

Ready {
    id: root

    titleRightContent: [
        VCB.Button {
            state: "medium"
            highlighted: true
            text: qsTr("View setup page")

            onClicked: A.ASetup.viewFromStatus()
        }
    ]
}