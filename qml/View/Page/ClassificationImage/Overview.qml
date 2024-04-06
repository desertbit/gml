import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts


import Store
import Theme

import View.Component.AnomalyBox as VCABox
import View.Component.AnomalyClass as VCA
import View.Component.Button as VCB
import View.Component.Container as VCC
import View.Component.Dialog as VCD
import View.Component.Image as VCImg
import View.Component.List as VCL

VCC.PageSelectionLayout {
    id: root

    //: The images of a product used to train the classification AI model.
    title: qsTr("Classification images")
    nonAvailableMessage: Store.state.classificationImageOverview.images.empty() ? "- " + qsTr("No images found") + " -" : ""

    QtObject {
        id: _

        readonly property int columns: 4
        readonly property int rows: 4
        // Number of items that fit in the image grid.
        readonly property int numItems: columns * rows
    }

    headerItem: VCL.HeaderBar {
        RowLayout {
            anchors.fill: parent
            spacing: Theme.spacingS

            VCL.SelectionCancelButton {
                id: selectionCancel

                visible: root.selector.selectionMode
                selector: root.selector

                Layout.rightMargin: Theme.spacingM
            }

            VCB.Button {
                highlighted: true
                text: qsTr("Select")

                onClicked: root.selector.startSelection()
                visible: !root.selector.selectionMode
            }

            Item { Layout.fillWidth: true }

            VCL.PaginationControl {
                id: pageCtrl

                totalPages: Math.ceil(totalElements / _.numItems)
                totalElements: Store.state.classificationImageOverview.images.length
                remainingElements: -1 // No filter
            }
        }
    }

    content: GridLayout {
        id: grid

        columns: _.columns
        columnSpacing: Theme.spacingXS
        rowSpacing: columnSpacing

        Repeater {
            id: repeater

            // Select the part of ids to be shown from the currently selected page.
            model: Store.state.classificationImageOverview.images.slice((pageCtrl.page - 1) * _.numItems, pageCtrl.page * _.numItems)

            VCImg.Image {
                id: delegate

                required property var modelData

                readonly property bool selected: root.selector.selected(modelData.id, root.selector.numSelected)

                cache: false
                source: `image://imgprov/customtrainimage/${Store.state.classificationImageOverview.productID}/${modelData.id}`
                fillMode: Image.PreserveAspectFit

                Layout.preferredWidth: (grid.width - (grid.columnSpacing * (_.columns - 1))) / _.columns
                Layout.preferredHeight: (grid.height - (grid.rowSpacing * (_.rows - 1))) / _.rows
                Layout.alignment: Qt.AlignTop | Qt.AlignLeft

                Flow {
                    anchors {
                        fill: parent
                        margins: Theme.spacingXXS
                    }
                    spacing: Theme.spacingXXS
                    layoutDirection: Qt.RightToLeft

                    Repeater {
                        // Extract the distinct anomaly classes from all anomaly boxes of this image.
                        model: modelData.anomalyBoxes.
                                    map(b => Store.view.anomalyClassByID(b.anomalyClassID)).
                                    filter((value, index, self) => index === self.findIndex(c => (c.id === value.id)))

                        delegate: VCA.BoxDelegate {
                            padding: 6
                        }
                    }
                }

                VCL.SelectionOverlay {
                    anchors.fill: parent
                    selected: parent.selected
                    visible: root.selector.selectionMode
                }

                // Takes care of emitting the correct signal based on whether the item is currently selected 
                // and if the selection mode is active or not.
                VCL.SelectionTapHandler {
                    selectionMode: root.selector.selectionMode
                    isSelected: parent.selected

                    onSelected: root.selector.select(delegate.modelData.id)
                    onDeselected: root.selector.deselect(delegate.modelData.id)
                    onTapped: A.A.AClassificationImageDetail.view(delegate.modelData.id)
                }
            }
        }

        // Pushes content to the left when not enough images are available.
        Item { Layout.fillWidth: true; visible: repeater.count < _.columns }
        // Pushes content to the top when not enough images are available.
        Item { Layout.fillHeight: true; visible: (repeater.count / _.columns) < _.rows; Layout.columnSpan: _.columns }
    }

    actions: [
        Item { Layout.fillHeight: true }, // Filler

        VCB.ActionButton {
            icon.source: "qrc:/resources/icons/delete.svg"
            fontColor: Theme.colorForeground
            backgroundColor: Theme.colorBackground

            Layout.fillWidth: true

            onClicked: A.AClassificationImage.remove(Store.state.classificationImageOverview.productID, root.selector.selectedIDs()).then(() => {
                // Reset local state to first page.
                pageCtrl.page = 1
                root.selector.deselectAll()
            })
        }
    ]
}