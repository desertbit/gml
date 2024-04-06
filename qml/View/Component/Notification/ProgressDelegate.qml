import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action as A
import Lib as L
import Theme

import View.Component.Button as VCB

// A notification item that displays a task with a progress.
// The modelData property is globally available to all items here.
RowLayout {
    id: root

    ColumnLayout {
        Text {
            text: L.Tr.notification(modelData.type)
            font {
                pixelSize: Theme.fontSizeM
                weight: Font.DemiBold
            }
            color: Theme.colorForegroundTier2
            wrapMode: Text.WordWrap

            Layout.fillWidth: true
        }

        ProgressBar {
            value: modelData.data.progress
            indeterminate: modelData.data.progress === -1

            Layout.fillWidth: true
        }
    }

    VCB.RoundIconButton {
        fontIcon {
            name: "x"
            size: Theme.iconSizeXS
        }
        flat: true
        padding: Theme.spacingXXS

        onClicked: A.AInternal.emitCancel(modelData.callID)
    }
}