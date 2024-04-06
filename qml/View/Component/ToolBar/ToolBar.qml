import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action as A
import Lib as L
import Store
import Theme

import View.Component.Button as VCB
import View.Component.Dev as VCDev
import View.Component.Notification as VCN

ToolBar {
    id: root

    property alias fixedLeftContent: fixedLeftContainer.data
    property alias rightContent: rightContainer.data

    Material.elevation: 0

    RowLayout {
        anchors {
            leftMargin: Theme.spacingXXXS
            rightMargin: Theme.spacingXXXS
            fill: parent
        }
        spacing: Theme.spacingXXS

        Image {
            id: logoApplication

            mipmap: true
            horizontalAlignment: Image.AlignLeft
            fillMode: Image.PreserveAspectFit
            source: "qrc:/resources/images/logo-nline-white"

            Layout.minimumWidth: height * 654 / 143
            Layout.preferredWidth: height * 654 / 143
            Layout.fillHeight: true
            Layout.margins: Theme.spacingS
        }

        // Static content on the left side.
        RowLayout {
            id: fixedLeftContainer

            spacing: Theme.spacingXS

            Layout.leftMargin: Theme.spacingM
            Layout.alignment: Qt.AlignVCenter
        }

        Item { Layout.fillWidth: true } // Filler

        // Dynamic content on the right side.
        RowLayout {
            id: rightContainer

            spacing: Theme.spacingXS

            Layout.alignment: Qt.AlignVCenter
        }

        // Static content on the right side.
        RowLayout {
            spacing: Theme.spacingXS

            Layout.alignment: Qt.AlignVCenter

            VCB.ToolIconButton {
                fontIcon.name: "zap"
                toolTipText: qsTr("Debug data")
                visible: Store.state.loggedIn && Store.state.app.opts.debugMode

                onClicked: devStateDialog.open()

                VCDev.StateDialog {
                    id: devStateDialog

                    y: parent.height
                    margins: 2
                }
            }

            VCB.ToolIconButton {
                fontIcon.name: "bell"
                toolTipText: qsTr("Notifications")
                visible: Store.state.app.showNotifications

                onClicked: {
                    // Toggle the notifications view.
                    if (notifications.visible) {
                        notifications.close()
                    } else {
                        A.ANotification.markRead()
                        notifications.open()
                    }
                }

                VCN.Badge {
                    count: Store.state.notifications.unread
                }

                VCN.ListPopup {
                    id: notifications
                }
            }

            VCB.ToolIconButton {
                fontIcon.name: "help-circle"
                toolTipText: qsTr("Help")
                visible: Store.state.loggedIn

                onClicked: A.AHelp.view()
            }

            VCB.ToolIconButton {
                fontIcon.name: "settings"
                toolTipText: qsTr("Settings")
                visible: Store.state.app.showSettings

                onClicked: A.ASettings.view()
            }

            VCB.ToolButton {
                text: Store.state.locale.substring(0, 2)
                font.pixelSize: Theme.fontSizeL
                toolTipText: qsTr("Language")

                onClicked: menuLang.open()

                Menu {
                    id: menuLang

                    x: parent.width - width
                    y: parent.height

                    Repeater {
                        model: Store.state.locales

                        MenuItem {
                            text: L.Tr.locale(modelData)

                            onTriggered: A.AApp.switchLocale(modelData)
                        }
                    }
                }
            }

            // Time
            Text {
                color: Theme.colorOnPrimary
                font.pixelSize: Theme.fontSizeL

                Layout.leftMargin: Theme.spacingS
                Layout.rightMargin: Theme.spacingS
                Layout.preferredWidth: 80

                Timer {
                    interval: 1000
                    repeat: true
                    running: true
                    triggeredOnStart: true

                    onTriggered: {
                        const now = new Date()
                        parent.text = now.toLocaleTimeString(Qt.locale(Store.state.locale), "hh:mm:ss")

                        // Compensate for slight invariances.
                        now.setSeconds(now.getSeconds()+1)
                        interval = 1000 - now.getMilliseconds()
                    }
                }
            }

            VCB.ToolIconButton {
                fontIcon.name: "power"
                toolTipText: qsTr("Quit")

                onClicked: menuMore.open()

                component MyMenuItem: MenuItem {
                    height: visible ? implicitHeight : 0
                }

                Menu {
                    id: menuMore

                    x: parent.width - width
                    y: parent.height

                    MyMenuItem {
                        visible: !Store.state.app.opts.withAutoLogin && Store.state.loggedIn
                        text: qsTr("Logout")

                        onTriggered: confirmLogout.open()
                    }

                    MyMenuItem {
                        text: qsTr("Quit nVision")

                        onTriggered: confirmQuit.open()
                    }

                    MenuSeparator { visible: Store.state.loggedIn }

                    MyMenuItem {
                        visible: Store.state.loggedIn && Store.state.app.opts.devMode
                        text: qsTr("nLine - Reboot")

                        onTriggered: A.ASettings.rebootNLine()
                    }

                    MyMenuItem {
                        visible: Store.state.loggedIn
                        text: qsTr("nLine - Shutdown")

                        onTriggered: A.ASettings.shutdownNLine()
                    }
                }

                ConfirmPopup {
                    id: confirmLogout

                    text: qsTr("Logout?")

                    onConfirmed: A.ALogin.logout()
                }

                ConfirmPopup {
                    id: confirmQuit

                    text: qsTr("Quit?")

                    onConfirmed: A.AApp.quit()
                }
            }
        }
    }
}
