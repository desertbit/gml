import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action as A
import Lib as L
import Store
import Theme

import View.Component.Button as VCB
import View.Component.Handler as VCH

// A notification item that displays that a nVision update is available.
// The modelData property is globally available to all items here.
Rectangle {
    id: root

    color: hover.hovered ? Qt.darker(Theme.colorBackground, 1.1) : Theme.colorBackground
    implicitHeight: content.implicitHeight

    Layout.fillWidth: true

    ColumnLayout {
        id: content

        anchors {
            left: parent.left
            right: parent.right
        }
        spacing: Theme.spacingXXXS

        Text {
            text: qsTr("Update available")
            font {
                pixelSize: Theme.fontSizeM
                weight: Font.DemiBold
            }
            color: Theme.colorForegroundTier2

            Layout.fillWidth: true
        }

        Text {
            text: qsTr("Click here to download version %1").arg(Store.state.nline.nlineVersion)
            font {
                pixelSize: Theme.fontSizeM
            }
            color: Theme.colorForegroundTier2
            wrapMode: Text.WordWrap

            Layout.fillWidth: true
        }
    }

    HoverHandler {
        id: hover
    }

    VCH.Tap {
        onTapped: A.AGlobal.downloadNVisionAndRestart()
    }
}