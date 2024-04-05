import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Lib
import Theme

import View.Component.Button as VCB
import View.Component.Container as VCC
import View.Component.Icon as VCI

VCC.Pane {
    id: root

    property alias icon: icon.name
    property alias title: title.text
    property alias description: description.text
    property alias withDownload: download.visible
    property alias withView: view.visible

    default property alias data: additionalContent.data
    property alias additionalContentSpacing: additionalContent.spacing

    signal viewClicked()
    signal downloadClicked()

    ColumnLayout {
        anchors.fill: parent
        spacing: Theme.spacingS

        Rectangle {
            readonly property int padding: Theme.spacingM

            border.color: Theme.colorAccent
            color: Theme.colorBackgroundTier2
            radius: 4

            Layout.preferredWidth: content.width + (2*padding)
            Layout.preferredHeight: content.height + (2*padding)

            ColumnLayout {
                id: content

                anchors.centerIn: parent

                VCI.Icon {
                    id: icon

                    size: Theme.fontSizeXXXL*2
                    color: Material.color(Material.Orange)

                    Layout.alignment: Qt.AlignHCenter
                    Layout.bottomMargin: Theme.spacingS
                }

                Text {
                    id: title

                    font {
                        weight: Font.Bold
                        pixelSize: Theme.fontSizeM
                    }
                    horizontalAlignment: Text.AlignHCenter

                    Layout.fillWidth: true
                    Layout.bottomMargin: Theme.spacingL
                }

                Text {
                    id: description

                    font {
                        weight: Font.Medium
                        pixelSize: Theme.fontSizeM
                    }
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap

                    Layout.fillWidth: true
                    Layout.maximumWidth: 280
                    Layout.bottomMargin: Theme.spacingXL
                }

                Item { Layout.fillHeight: true }
            }
        }

        ColumnLayout {
            id: additionalContent
        }

        Row {
            spacing: Theme.spacingS

            Layout.alignment: Qt.AlignHCenter

            VCB.Button {
                id: view

                text: qsTr("View")
                highlighted: true
                state: "medium"

                onClicked: root.viewClicked()
            }

            VCB.Button {
                id: download

                text: qsTr("Download")
                highlighted: true
                state: "medium"

                onClicked: root.downloadClicked()
            }
        }
    }
}
