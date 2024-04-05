import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action.EventOverview as AEventOverview
import Action.Run as ARun
import Action.RunExport as ARunExport
import Action.RunRecentDetail as ARunRecentDetail
import Action.RunRecentOverview as ARunRecentOverview

import Lib as L
import Store
import Theme

import View.Component.Button as VCB
import View.Component.Container as VCC
import View.Component.Date as VCD
import View.Component.Form as VCF
import View.Component.List as VCL
import View.Component.Run as VCR

VCC.PageSelectionLayout {
    id: root

    title: qsTr("Latest batches")
    nonAvailableMessage: Store.state.runRecentOverview.page.empty() ? "- " + qsTr("No batch available") + " -" : ""

    Component.onCompleted: ARunRecentOverview.setLimit(_.numItems)

    QtObject {
        id: _

        // The height of a list delegate.
        readonly property real listDelegateHeight: 80
        // Number of items that fit in the content list.
        readonly property int numItems: list.height > 0 ? Math.ceil(list.height / (listDelegateHeight + list.spacing)) : 0
    }

    headerItem: VCL.HeaderBar {
        RowLayout {
            anchors.fill: parent
            spacing: Theme.spacingM

            VCL.SelectionCancelButton {
                id: selectionCancel

                visible: false
                selector: root.selector

                Layout.rightMargin: Theme.spacingM
            }

            VCF.LabeledColumnLayout {
                labelText: qsTr("Product name")
                label.font.weight: Font.DemiBold
                spacing: 0

                VCF.TextField {
                    id: productName

                    font.pixelSize: Theme.fontSizeM
                    text: Store.state.runRecentOverview.filter.productName

                    Layout.preferredWidth: 206
                }
            }

            VCF.LabeledColumnLayout {
                labelText: qsTr("Batch name")
                label.font.weight: Font.DemiBold
                spacing: 0

                VCF.TextField {
                    id: runName

                    font.pixelSize: Theme.fontSizeM
                    text: Store.state.runRecentOverview.filter.runName

                    Layout.preferredWidth: 206
                }
            }

            VCF.LabeledColumnLayout {
                labelText: qsTr("From")
                label.font.weight: Font.DemiBold
                spacing: 0

                VCD.TextField {
                    id: after

                    time: true
                    textField.font.pixelSize: Theme.fontSizeM
                    ts: Store.state.runRecentOverview.filter.afterTS
                    maxDate: before.ts
                }
            }

            VCF.LabeledColumnLayout {
                labelText: qsTr("To")
                label.font.weight: Font.DemiBold
                spacing: 0

                VCD.TextField {
                    id: before

                    time: true
                    textField.font.pixelSize: Theme.fontSizeM
                    ts: Store.state.runRecentOverview.filter.beforeTS
                    minDate: after.ts
                }
            }

            VCB.Button {
                id: search

                text: qsTr("Search")
                highlighted: true
                state: "medium"
                enabled: productName.text !== Store.state.runRecentOverview.filter.productName ||
                         runName.text !== Store.state.runRecentOverview.filter.runName ||
                         L.LDate.differ(after.ts, Store.state.runRecentOverview.filter.afterTS) ||
                         L.LDate.differ(before.ts, Store.state.runRecentOverview.filter.beforeTS)

                onClicked: {
                    pageCtrl.page = 1
                    ARunRecentOverview.setFilter(productName.text, runName.text, after.ts, before.ts)
                }
            }

            VCB.Button {
                text: qsTr("Reset filter")
                enabled: productName.text !== "" || runName.text !== "" || after.ts.valid() || before.ts.valid()
                state: "medium"

                onClicked: {
                    pageCtrl.page = 1
                    productName.text = ""
                    runName.text = ""
                    after.ts = L.LDate.Invalid
                    before.ts = L.LDate.Invalid
                    ARunRecentOverview.setFilter("", "", "", "")
                }
            }

            Item { Layout.fillWidth: true } // Filler

            VCL.PaginationControl {
                id: pageCtrl

                totalPages: Math.ceil(remainingElements / _.numItems)
                totalElements: Store.state.runRecentOverview.totalCount
                remainingElements: Store.state.runRecentOverview.filteredCount

                onPrev: ARunRecentOverview.loadPrevPage()
                onNext: ARunRecentOverview.loadNextPage()
            }
        }
    }

    content: ColumnLayout {
        id: list

        spacing: 0

        Repeater {
            id: repeater

            model: Store.state.runRecentOverview.page

            VCR.ListDelegate {
                recent: true
                canSelect: true
                inset: Theme.spacingM
                isSelected: root.selector.selected(modelData.id, root.selector.numSelected)
                selectEnabled: true
                selectionMode: root.selector.selectionMode

                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.maximumHeight: _.listDelegateHeight
                Layout.alignment: Qt.AlignTop

                onSelected: id => root.selector.select(id)
                onDeselected: id => root.selector.deselect(id)
                onTapped: id => ARunRecentDetail.view(id)
                onShowEvents: (productID, runID) => AEventOverview.viewFromRunRecentOverview(productID, runID)
            }
        }

        // Pushes content to top, if not enough elements are available.
        Item { Layout.fillHeight: repeater.count < _.numItems }
    }

    actions: [
        VCB.ActionButton {
            icon.source: "qrc:/resources/icons/export_notes.svg"
            text: qsTr("Export")
            fontColor: Theme.colorOnExport
            backgroundColor: Theme.colorExport

            Layout.fillWidth: true

            onClicked: ARunExport.view(root.selector.selectedIDs())
        },

        Item { Layout.fillHeight: true }, // Filler

        VCB.ActionButton {
            icon.source: "qrc:/resources/icons/delete.svg"
            fontColor: Theme.colorForeground
            backgroundColor: Theme.colorBackground

            Layout.fillWidth: true

            onClicked: ARun.remove(root.selector.selectedIDs()).then(() => {
                // Reset local state to first page.
                pageCtrl.page = 1
                root.selector.deselectAll()
            })
        }
    ]
}
