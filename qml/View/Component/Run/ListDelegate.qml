import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import Action as A
import Lib as L
import Theme
import Store

import View.Component.Button as VCB
import View.Component.Icon as VCI
import View.Component.Image as VCImg
import View.Component.List as VCL

// To be used as delegate in e.g. a ListView or Repeater.
// Width and height must be set.
Rectangle {
    id: root

    required property var modelData  // Model.Run or Model.RecentRun
    required property int index

    // If true, the run is a recent run and should show information about its product.
    // The modelData must contain a Model.RecentRun in this case.
    property bool recent: false

    // The inset of the left and right edges.
    property real inset: 0
    // When true, the background color starts at the second color for the first item.
    property bool invertBackgroundColorOrder: false

    // If true, the list button is hidden and the showEvents signal can not be emitted.
    property bool hideList: false

    // Whether a select box should be shown.
    property alias canSelect: selectBox.visible
    // True, if the delegate is currently selected.
    property bool isSelected: false
    // Whether the select box is enabled.
    property alias selectEnabled: selectBox.enabled
    // Should be true, when a selection is currently active.
    // The delegate will then emit selected and deselected instead
    // of tapped signals, when the user clicks anywhere on the delegate.
    property bool selectionMode: false

    // Emitted when the user clicks anywhere on the delegate.
    signal tapped(int id)
    // Emitted when the user selects the delegate via the checkbox.
    signal selected(int id)
    // Emitted when the user deselects the delegate via the checkbox.
    signal deselected(int id)
    // Emitted when the user presses the show events button.
    signal showEvents(int productID, int runID)

    color: hover.hovered
           ? Theme.listDelegateBackgroundHighlight
           : (index % 2 === (invertBackgroundColorOrder ? 1 : 0) ? Theme.listDelegateBackground1 : Theme.listDelegateBackground2)

    // Sync checkbox with state.
    onIsSelectedChanged: selectBox.checked = isSelected

    states: [
        State {
            name: "failed"
            when: root.modelData.hasFailed
            PropertyChanges { target: name; color: Theme.error }
            PropertyChanges { target: finished; text: qsTr("Failed"); font.weight: Font.DemiBold }
        },
        State {
            name: "finished"
            when: root.modelData.isFinished
            PropertyChanges {
                target: finished
                font.weight: Font.Normal
                text: qsTr("Finished on %1").arg(root.modelData.finished.formatDateTime(Store.state.locale))
            }
        }
    ]

    // Takes care of emitting the correct signal based on whether the item is currently selected 
    // and if the selection mode is active or not.
    VCL.SelectionTapHandler {
        selectionMode: root.selectionMode
        isSelected: root.isSelected

        onSelected: root.selected(root.modelData.id)
        onDeselected: root.deselected(root.modelData.id)
        onTapped: root.tapped(root.modelData.id)
    }

    RowLayout {
        anchors {
            fill: parent
            topMargin: 4
            bottomMargin: 4
            leftMargin: root.inset
            rightMargin: root.inset
        }
        spacing: Theme.spacingS

        CheckBox {
            id: selectBox

            visible: false

            onToggled: {
                // Emit signal.
                if (checked) {
                    root.selected(root.modelData.id)
                } else {
                    root.deselected(root.modelData.id)
                }
            }
        }

        // Product thumbnail.
        VCImg.Image {
            source: root.recent ? root.modelData.productThumbnailSource : ""
            fillMode: Image.PreserveAspectFit
            visible: root.recent

            Layout.fillHeight: true
            Layout.preferredWidth: height*2.5
        }

        ColumnLayout {
            spacing: Theme.spacingXXS

            Layout.minimumWidth: 190
            Layout.maximumWidth: 190

            Text {
                id: name

                font {
                    weight: Font.DemiBold
                    pixelSize: Theme.fontSizeM
                }
                text: root.modelData.name
                elide: Text.ElideRight

                Layout.fillWidth: true
            }

            // ProductName
            Text {
                font {
                    weight: Font.DemiBold
                    pixelSize: Theme.fontSizeM
                }
                color: Theme.colorForegroundTier2
                text: root.recent ? root.modelData.productName : ""
                elide: Text.ElideRight
                visible: root.recent

                Layout.fillWidth: true
            }
        }

        ColumnLayout {
            spacing: Theme.spacingXXS

            Layout.minimumWidth: 190
            Layout.maximumWidth: 190

            Text {
                font.pixelSize: Theme.fontSizeS
                color: Theme.colorForegroundTier2
                text: qsTr("Created on %1").arg(root.modelData.created.formatDateTime(Store.state.locale))
                elide: Text.ElideRight
            }

            Text {
                id: finished

                font {
                    weight: Font.DemiBold
                    pixelSize: Theme.fontSizeS
                }
                color: Theme.colorForegroundTier2
                text: qsTr("Currently active")
                elide: Text.ElideRight
            }
        }

        ColumnLayout {
            spacing: Theme.spacingXXS

            Text {
                font.pixelSize: Theme.fontSizeS
                color: Theme.colorForegroundTier2
                text: qsTr("Number of events: %1").arg(root.modelData.numEvents)
                elide: Text.ElideLeft

                Layout.fillWidth: true
            }
            Text {
                font.pixelSize: Theme.fontSizeS
                color: Theme.colorForegroundTier2
                text: qsTr("Sensitivity preset: %1").arg(L.Tr.sensitivityPreset(root.modelData.sensitivityPreset))
                elide: Text.ElideLeft
            }
        }

        // Filler
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        Text {
            font.pixelSize: Theme.fontSizeS
            color: Theme.colorForegroundTier2
            text: qsTr("ID: %1").arg(root.modelData.id)
            elide: Text.ElideLeft
        }

        VCB.RoundIconButton {
            fontIcon.name: "list"
            flat: true
            visible: !root.hideList

            onClicked: root.showEvents(root.modelData.productID, root.modelData.id)
        }
    }

    HoverHandler {
        id: hover
    }
}
