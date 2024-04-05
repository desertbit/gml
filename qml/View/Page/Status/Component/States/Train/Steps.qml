import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Lib as L
import Store
import Theme

import View.Component.Icon as VCI

GridLayout {
    id: root

    property alias model: repeater.model

    rowSpacing: Theme.spacingS
    columnSpacing: Theme.spacingXS
    columns: 4

    Repeater {
        id: repeater

        Item {
            id: delegate

            required property var modelData

            states: [
                State {
                    name: "active"
                    when: Store.state.nline.state === delegate.modelData
                    PropertyChanges { target: delegateIcon; color: Theme.colorForeground }
                    PropertyChanges { target: delegateText; color: Theme.colorForeground }
                    PropertyChanges {
                        target: delegateProgressBar
                        indeterminate: Store.state.nline.stateProgress < 0
                        value: Store.state.nline.stateProgress
                    }
                    PropertyChanges {
                        target: delegateProgressBarLabel
                        opacity: delegateProgressBar.indeterminate ? 0 : 1
                    }
                },
                State {
                    name: "done"
                    when: L.State.isTrain(Store.state.nline.state) && Store.state.nline.state > delegate.modelData
                    PropertyChanges { target: delegateIcon; color: Theme.success; name: "check-square" }
                    PropertyChanges { target: delegateText; color: Theme.success }
                    PropertyChanges { target: delegateProgressBar; value: 1 }
                }
            ]

            Component.onCompleted: {
                // Reparent all child elements into the grid.
                // That allows us to define a single delegate that gets split
                // into its children upon creation.
                while (children.length) {
                    children[0].parent = root
                }
            }

            VCI.Icon {
                id: delegateIcon

                size: Theme.fontSizeXL
                name: "square"
                color: Theme.colorForegroundTier2
            }
            Text {
                id: delegateText

                font.pixelSize: Theme.fontSizeL
                text: L.State.shortName(delegate.modelData)
                color: Theme.colorForegroundTier2

                Layout.rightMargin: Theme.spacingXS
            }
            ProgressBar {
                id: delegateProgressBar

                Layout.fillWidth: true
            }
            Text {
                id: delegateProgressBarLabel

                text: `${L.LMath.roundToFixed(delegateProgressBar.value*100, 0)}%`
                font.pixelSize: Theme.fontSizeL
                opacity: 0
            }
        }
    }
}
