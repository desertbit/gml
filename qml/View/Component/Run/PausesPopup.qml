import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Lib as L
import Store
import Theme

Popup {
    id: root

    // The array of run pauses that should be displayed.
    required property var pauses

    margins: 4
    padding: Theme.spacingS

    GridLayout {
        id: grid

        anchors.fill: parent
        columns: 4
        columnSpacing: Theme.spacingXS

        Repeater {
            model: root.pauses

            Item {
                id: delegate

                required property var modelData

                Component.onCompleted: {
                    // Reparent all child elements into the grid.
                    // That allows us to define a single delegate that gets split
                    // into its children upon creation.
                    while (children.length) {
                        children[0].parent = grid
                    }
                }

                Text {
                    font.pixelSize: Theme.fontSizeM
                    text: delegate.modelData.paused.formatDateTime(Store.state.locale)
                }

                Text {
                    font.pixelSize: Theme.fontSizeM
                    text: "→"
                }

                Text {
                    font.pixelSize: Theme.fontSizeM
                    text: delegate.modelData.resumed.valid() ? delegate.modelData.paused.formatDateTime(Store.state.locale) : "---"
                }

                Text {
                    font.pixelSize: Theme.fontSizeM
                    text: visible ? `(${L.LDate.formatDuration(delegate.modelData.resumed - delegate.modelData.paused)})` : ""
                    visible: delegate.modelData.resumed.valid()
                }
            }
        }
    }
}
