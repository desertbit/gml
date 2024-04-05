import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

import Theme
import View.Component.Effect as VCE
import View.Component.Icon as VCI

Pane {
    id: root

    // Title
    property alias titleText: title.text
    readonly property alias title: title

    // Title Icon
    property alias titleIconName: titleIcon.name
    property alias titleIconColor: titleIcon.color
    readonly property alias titleIcon: titleIcon

    // Header Left Content
    property alias titleLeftContent: headerLeftContent.children
    property alias titleLeftContentSpacing: headerLeftContent.spacing

    // Header Right Content
    property alias titleRightContent: headerRightContent.children
    property alias titleRightContentSpacing: headerRightContent.spacing

    // Header / Content Separator
    readonly property alias separator: separator
    property alias separatorVisible: separator.visible

    // Content
    default property alias data: content.data
    property alias contentSpacing: content.spacing
    readonly property alias content: content

    property int radius: 5

    padding: Theme.spacingS

    Material.elevation: 2

    background: VCE.BackgroundShadow {}

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Header
        RowLayout {
            id: header

            VCI.Icon {
                id: titleIcon

                size: Theme.iconSizeS
            }

            Text {
                id: title

                font {
                    pixelSize: Theme.fontSizeM
                    weight: Font.DemiBold
                }
            }

            RowLayout { id: headerLeftContent }

            Item { Layout.fillWidth: true }

            RowLayout { id: headerRightContent }
        }

        // Separator
        Rectangle {
            id: separator

            color: Theme.colorBackgroundTier2

            Layout.topMargin: Theme.spacingXS
            Layout.bottomMargin: Theme.spacingS
            Layout.fillWidth: true
            Layout.preferredHeight: 1
        }

        // Content
        ColumnLayout {
            id: content

            spacing: Theme.spacingS
        }
    }
}
