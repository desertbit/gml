import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material


import Theme

import View.Component.Container as VCC
import View.Component.Form as VCF

VCC.IconPane {
    titleText: qsTr("Custom address")
    titleRightContentSpacing: 5
    titleIconName: "edit"
    titleIconColor: Material.color(Material.Blue)
    title.font.pixelSize: Theme.fontSizeL
    title.horizontalAlignment: Text.AlignHCenter
    separator.color: Theme.colorSeparator

    states: [
        State {
            name: "valid"
            when: input.text !== ""
            PropertyChanges { target: input; Keys.enabled: true }
            PropertyChanges { target: connect; enabled: true }
        }
    ]

    Text {
        text: qsTr("Enter the address of the nLine device")
        font {
            pixelSize: Theme.fontSizeM
            weight: Font.DemiBold
        }
        wrapMode: Text.WordWrap
        padding: Theme.spacingXS

        Layout.fillWidth: true
    }

    VCF.TextField {
        id: input

        placeholderText: qsTr("Address") + "..."

        Layout.fillWidth: true
        Layout.leftMargin: Theme.spacingM

        Keys.enabled: false
        Keys.onReturnPressed: A.ALoginConnect.view(text)
    }

    Button {
        id: connect

        highlighted: true
        text: qsTr("Connect")
        font {
            pixelSize: Theme.fontSizeL
            capitalization: Font.MixedCase
        }
        horizontalPadding: Theme.spacingM
        verticalPadding: Theme.spacingS
        enabled: false

        Layout.alignment: Qt.AlignHCenter
        Layout.topMargin: Theme.spacingM

        onClicked: A.ALoginConnect.view(input.text)
    }

    Item { Layout.fillHeight: true } // Filler
}
