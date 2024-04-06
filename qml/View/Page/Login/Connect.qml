import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

import Action as A
import Lib as L
import Theme
import Store

import View.Component.Button as VCB
import View.Component.Container as VCC
import View.Component.Logo as VCL

import "Component"

VCC.Page {
    id: root

    title: qsTr("Connect")

    states: [
        State {
            name: "initializing"
            when: Store.state.loginConnect.initializing
            PropertyChanges { target: msg; text: qsTr("The nLine device is initializing...") }
        },
        State {
            name: "connectionRefused"
            when: Store.state.loginConnect.connectionRefused            
            PropertyChanges { 
                target: msg
                color: Theme.error
                //: The argument is an IP address (e.g. 192.168.0.1).
                text: qsTr("The remote device at '%1' refused to connect.\nIs the nLine service running?").arg(Store.state.loginConnect.addr)
            }
        },
        State {
            name: "error"
            when: Store.state.loginConnect.err !== ""
            PropertyChanges { target: msg; text: L.Tr.err(Store.state.loginConnect.err); color: Theme.error }
        }
    ]

    VCB.RoundIconButton {
        anchors {
            verticalCenter: parent.verticalCenter
            right: content.left
            margins: Theme.spacingM
        }
        fontIcon {
            name: "arrow-left"
            size: Theme.iconSizeL
        }
        flat: true
        // Show only, if no auto login is active.
        // The user can then go back to the Discovery page.
        visible: !Store.state.app.opts.withAutoLogin

        onClicked: A.ANavigation.popPage()
    }

    ColumnLayout {
        id: content

        anchors {
            top: parent.top
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            margins: Theme.spacingL
        }
        spacing: Theme.spacingL
        width: 600

        VCL.Banner {}

        VCC.IconPane {
            //: Connecting to a server, device, etc.
            titleText: qsTr("Connecting")
            titleRightContentSpacing: 5
            titleIconName: "log-in"
            titleIconColor: Material.color(Material.LightBlue)
            title.font.pixelSize: Theme.fontSizeL
            title.horizontalAlignment: Text.AlignHCenter
            separator.color: Theme.colorSeparator

            Layout.fillHeight: true
            Layout.fillWidth: true

            Text {
                text: Store.view.loginConnectAddrIsLocalhost
                      ? qsTr("nVision is connecting to nLine") + "..."
                      : qsTr("nVision is connecting to the nLine device at address")
                font {
                    pixelSize: Theme.fontSizeXL
                }
                wrapMode: Text.WordWrap
                horizontalAlignment: Qt.AlignHCenter

                Layout.fillWidth: true
                Layout.topMargin: Theme.spacingL
            }

            Text {
                text: Store.state.loginConnect.addr
                font {
                    pixelSize: Theme.fontSizeXL
                    weight: Font.DemiBold
                    italic: true
                }
                visible: !Store.view.loginConnectAddrIsLocalhost

                Layout.alignment: Qt.AlignHCenter
            }

            BusyIndicator {
                running: true

                Layout.topMargin: Theme.spacingXXL
                Layout.preferredWidth: 75
                Layout.preferredHeight: width
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                color: Material.foreground
                font.pixelSize: Theme.fontSizeL
                text: qsTr("Retry login in %1s").arg(Store.state.loginConnect.secondsUntilRetry)
                visible: Store.state.loginConnect.secondsUntilRetry > 0
                horizontalAlignment: Qt.AlignHCenter

                Layout.topMargin: Theme.spacingM
                Layout.fillWidth: true
            }

            Text {
                id: msg

                font {
                    pixelSize: Theme.fontSizeL
                    weight: Font.DemiBold
                }
                horizontalAlignment: Qt.AlignHCenter
                wrapMode: Text.WordWrap

                Layout.fillWidth: true
            }

            Item { Layout.fillHeight: true }
        }
    }
}
