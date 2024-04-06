import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action as A
import Lib as L
import Store
import Theme

import View.Component.Button as VCB
import View.Component.Container as VCC
import View.Component.Run as VCR

// General Info
VCC.IconPane {
    id: root

    titleText: qsTr("Selected Batches")
    titleIconName: "activity"
    titleIconColor: Theme.colorRun
    spacing: 0

    titleRightContent: [
        VCB.Button {
            highlighted: true
            text: qsTr("Preview PDF")
            horizontalPadding: Theme.spacingL
            enabled: _.runSelected

            onClicked: A.APDFPreview.viewReport(_.selectedRunID)
        }
    ]

    QtObject {
        id: _

        // The height of a list delegate.
        readonly property real listDelegateHeight: 60
        // True, if a run has been selected.
        readonly property bool runSelected: selectedRunID > 0

        // The id of the selected run.
        // If only one item is available, select it by default to quickly allow to see 
        // the pdf preview of the run.
        property int selectedRunID: list.model.length === 1 ? list.model[0].id : 0
    }

    ListView {
        id: list

        model: Store.state.runExport.runs

        Layout.fillWidth: true
        Layout.fillHeight: true

        delegate: VCR.ListDelegate {
            width: list.width
            height: _.listDelegateHeight
            inset: Theme.spacingM
            hideList: true
            canSelect: true
            selectEnabled: modelData.id === _.selectedRunID || !_.runSelected
            isSelected: modelData.id === _.selectedRunID
            invertBackgroundColorOrder: true

            onTapped: id => {
                if (isSelected) {
                    deselected(id)
                } else {
                    selected(id)
                }
            }
            onSelected: id => _.selectedRunID = id
            onDeselected: _.selectedRunID = 0
        }
    }
}
