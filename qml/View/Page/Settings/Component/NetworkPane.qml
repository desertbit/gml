import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action.Settings as ASettings

import Lib as L
import Store
import Theme

import View.Component.Button as VCB
import View.Component.ComboBox as VCCombo
import View.Component.Container as VCC
import View.Component.Form as VCF

// FIXME #0002: https://bugreports.qt.io/browse/QTBUG-111351
VCC.IconPane {
    id: root

    readonly property bool hasUnsavedChanges: mode.currentValue !== Store.state.settings.network.mode ||
                                              addr.text !== Store.state.settings.network.addr ||
                                              subnetPrefixLength.value !== Store.state.settings.network.subnetPrefixLength ||
                                              gateway.text !== Store.state.settings.network.gateway ||
                                              dns.text !== Store.state.settings.network.dns

    titleText: qsTr("Network")
    titleIconName: "globe"
    titleIconColor: Material.color(Material.LightBlue)
    contentSpacing: Theme.spacingM

    titleRightContent: VCB.Button {
        text: qsTr("Apply")
        highlighted: true
        enabled: root.hasUnsavedChanges && (mode === L.Con.NetworkMode.DHCP || addr.text !== "")

        onClicked: ASettings.updateNetwork(mode.currentValue, addr.text, subnetPrefixLength.value, gateway.text, dns.text)
    }

    ColumnLayout {
        RowLayout {
            Label {
                font.pixelSize: Theme.fontSizeM
                text: qsTr("Mode")
            }

            Item { Layout.fillWidth: true }

            VCCombo.ComboBox {
                id: mode

                function _elem(mode) {
                    return { text: L.Tr.networkMode(mode), value: mode }
                }

                syncTo: Store.state.settings.network.mode
                valueRole: "value"
                textRole: "text"
                model: [_elem(L.Con.NetworkMode.DHCP), _elem(L.Con.NetworkMode.Static)]
            }
        }

        GridLayout {
            columns: 2
            columnSpacing: Theme.spacingXL
            rowSpacing: Theme.spacingS
            visible: mode.currentValue === L.Con.NetworkMode.Static

            component GridLabel: Label {
                font.pixelSize: Theme.fontSizeM
            }

            component GridTextField: VCF.TextField {
                horizontalAlignment: TextInput.AlignRight

                Layout.fillWidth: true
            }

            // Row1
            GridLabel {
                //: An network or IP address.
                text: qsTr("Address")
            }

            GridTextField {
                id: addr

                placeholderText: qsTr("Address") + "..."
                text: Store.state.settings.network.addr
                inputMethodHints: Qt.ImhNoPredictiveText

                onTextChanged: {
                    // When the user starts to enter a custom address, fill in the default
                    // value of 24 for the subnet prefix.
                    if (text.length === 1 && subnetPrefixLength.value === 0) {
                        subnetPrefixLength.text = "24"
                    }
                }
            }

            // Row2
            GridLabel {
                //: The length of the subnet prefix, like the 24 in 10.71.71.1/24.
                text: qsTr("Subnet prefix length")
            }

            GridTextField {
                id: subnetPrefixLength

                readonly property int value: parseInt(text)

                placeholderText: qsTr("Subnet prefix length") + "..."
                text: Store.state.settings.network.subnetPrefixLength
                inputMethodHints: Qt.ImhDigitsOnly
                validator: IntValidator { bottom: 0; top: 32 }
            }

            // Row3
            GridLabel {
                //: The gateway of a local network.
                text: qsTr("Gateway")
            }

            GridTextField {
                id: gateway

                placeholderText: qsTr("Gateway") + "..."
                text: Store.state.settings.network.gateway
                inputMethodHints: Qt.ImhNoPredictiveText
            }

            // Row4
            GridLabel {
                //: Abbreviation for a domain name server.
                text: qsTr("DNS")
            }

            GridTextField {
                id: dns

                placeholderText: qsTr("DNS") + "..."
                text: Store.state.settings.network.dns
                inputMethodHints: Qt.ImhNoPredictiveText

                Layout.bottomMargin: Theme.spacingS
            }
        }

        VCF.HorDivider {
            Layout.topMargin: Theme.spacingS
            Layout.bottomMargin: Theme.spacingS
            Layout.leftMargin: Theme.spacingXS
            Layout.rightMargin: Theme.spacingXS
        }

        Label {
            font {
                pixelSize: Theme.fontSizeM
                weight: Font.DemiBold
            }
            //: As in network interfaces like an Ethernet port or Wifi.
            text: qsTr("Interfaces")

            Layout.bottomMargin: Theme.spacingXS
        }

        Repeater {
            model: Store.state.settings.networkInterfaces

            ColumnLayout {
                RowLayout {
                    spacing: Theme.spacingS

                    Text {
                        font {
                            pixelSize: Theme.fontSizeM
                            weight: Font.DemiBold
                        }
                        text: modelData.name

                        Layout.alignment: Qt.AlignTop
                    }

                    ColumnLayout {
                        spacing: Theme.spacingXXS

                        Text {
                            font.pixelSize: Theme.fontSizeM
                            text: (modelData.macAddr || "---") + " (MAC)"
                            horizontalAlignment: Qt.AlignRight

                            Layout.fillWidth: true
                        }

                        Repeater {
                            model: modelData.ipAddrs

                            Text {
                                font.pixelSize: Theme.fontSizeM
                                text: modelData
                                horizontalAlignment: Qt.AlignRight

                                Layout.fillWidth: true
                            }
                        }
                    }
                }

                VCF.HorDivider {}
            }
        }
    }
}
