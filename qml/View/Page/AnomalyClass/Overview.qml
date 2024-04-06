import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action as A
import Lib as L
import Store
import Theme

import View.Component.AnomalyClass as VCA
import View.Component.Button as VCB
import View.Component.Container as VCC
import View.Component.List as VCL

VCC.PageSelectionLayout {
    id: root

    title: qsTr("Anomaly classes")
    nonAvailableMessage: Store.state.anomalyClasses.empty() ? "- " + qsTr("No anomaly classes available") + " -" : ""

    headerItem: VCL.HeaderBar {
        RowLayout {
            anchors.fill: parent
            spacing: Theme.spacingM

            VCL.SelectionCancelButton {
                id: selectionCancel

                selector: root.selector
                visible: false

                Layout.rightMargin: Theme.spacingL
            }

            VCB.Button {
                highlighted: true
                text: qsTr("Select")

                onClicked: root.selector.startSelection()
                visible: !root.selector.selectionMode
            }

            Item { Layout.fillWidth: true }

            Text {
                text: qsTr("Total: %L1").arg(Store.state.anomalyClasses.length)
                font.pixelSize: Theme.fontSizeL
            }
        }
    }

    content: Flow {
        anchors.margins: Theme.spacingM
        spacing: Theme.spacingS

        Repeater {
            id: anomClasses

            model: Store.state.anomalyClasses.filter(ac => ac.id !== L.Con.AnomalyClass.Unclassified)

            // Hint:
            // The state of each delegate is reset every time the model above changes.
            // E.g.: Edit two classes at once and submit one. The other one will abort its editing.
            delegate: VCA.Delegate {
                readonly property bool isNoErr: modelData.id === 1

                editable: !isNoErr
                showLockIcon: isNoErr
                canSelect: !isNoErr
                isSelected: root.selector.selected(modelData.id, root.selector.numSelected)
                selectionMode: root.selector.selectionMode

                onSelected: id => root.selector.select(id)
                onDeselected: id => root.selector.deselect(id)
            }
        }

        // The delegate to create new classes.
        VCA.CreateDelegate {
            enabled: !root.selector.selectionMode
        }
    }

    actions: [
        Item { Layout.fillHeight: true }, // Filler

        VCB.ActionButton {
            icon.source: "qrc:/resources/icons/delete.svg"
            fontColor: Theme.colorOnAccent
            backgroundColor: Theme.colorAccent

            Layout.fillWidth: true
            Layout.minimumWidth: 150

            onClicked: A.AAnomalyClass.remove(root.selector.selectedIDs()).then(root.selector.deselectAll)
        }
    ]
}
