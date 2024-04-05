import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

import Action.LoginConnect as ALoginConnect

import Theme

import View.Component.Icon as VCI

// The DeviceList displays a list of discovery nLine devices.
// The model is expected to be a javascript array containing
// objects parsed from JSON of Go DiscoveryDevice structs.
ListView {
    id: root

    clip: true
    activeFocusOnTab: true
    focus: true
    keyNavigationEnabled: true
    keyNavigationWraps: true
    headerPositioning: ListView.OverlayHeader
    contentWidth: width - listScrollbar.width

    ScrollBar.vertical: ScrollBar {
        id: listScrollbar

        visible: root.count > 0
    }

    header: Rectangle {
        width: root.contentWidth
        z: 2
        implicitHeight: headerContent.implicitHeight + headerBorder.implicitHeight

        RowLayout {
            id: headerContent

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }

            Text {
                text: qsTr("Name")
                font.pixelSize: Theme.fontSizeM
                font.weight: Font.DemiBold
                padding: Theme.spacingXS

                Layout.fillWidth: true
            }

            Text {
                text: qsTr("Network Address")
                font.pixelSize: Theme.fontSizeM
                font.weight: Font.DemiBold
                padding: Theme.spacingXS
            }
        }

        Rectangle {
            id: headerBorder

            anchors {
                top: headerContent.bottom
                left: parent.left
                right: parent.right
            }
            color: "lightGrey"
            height: 1
        }
    }

    delegate: ItemDelegate {
        width: root.contentWidth
        height: 40
        highlighted: ListView.isCurrentItem

        onClicked: ALoginConnect.view(modelData.addr)

        Keys.enabled: true
        Keys.onReturnPressed: clicked()

        HoverHandler { cursorShape: Qt.PointingHandCursor }

        RowLayout {
            anchors {
                fill: parent
                margins: Theme.spacingXS
            }
            spacing: Theme.spacingXS

            Text {
                text: modelData.hostname
                elide: Text.ElideRight
                maximumLineCount: 1
                font {
                    weight: Font.Medium
                    pixelSize: Theme.fontSizeM
                }

                Layout.fillWidth: true
            }

            Text {
                text: modelData.addr
                elide: Text.ElideRight
                maximumLineCount: 1
                color: Theme.colorForegroundTier2
                font.pixelSize: Theme.fontSizeM
            }

            VCI.Icon {
                name: "arrow-right"
                size: Theme.fontSizeL
            }
        }

        Rectangle {
            anchors {
                right: parent.right
                bottom: parent.bottom
                left: parent.left
                rightMargin: Theme.spacingS
                leftMargin: Theme.spacingS
            }
            color: Theme.colorBackgroundTier2
            height: 1
            visible: index !== root.count - 1
        }
    }
}
