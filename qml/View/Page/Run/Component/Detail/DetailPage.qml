import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action as A
import Lib as L
import Store
import Store.Model as SM
import Theme

import View.Component.Button as VCB
import View.Component.Container as VCC
import View.Component.Form as VCF

VCC.Page {
    id: root

    required property SM.RunDetail model

    // If true, the view product action is displayed.
    property alias showViewProduct: viewProduct.visible
    // If true, the produc name is displayed in the title.
    property bool includeProductInTitle: false

    title: (root.model.skippedRunOverview ? qsTr("Batch") + " - " : "") +
           root.model.name +
           (includeProductInTitle ? ` (${root.model.productName})` : "")

    QtObject {
        id: _
            
        readonly property real infoRelWidth: 0.4
        readonly property real defectRelWidth: 0.25
        readonly property real measureRelWidth: 1 - infoRelWidth - defectRelWidth

        readonly property real paneHeight: content.height / 2
        readonly property real paneHalfWidth: (content.width / 2) - (content.spacing / 2)
        readonly property real thirdSpacing: (content.spacing * 2) / 3
        readonly property real infoWidth: (content.width * infoRelWidth) - thirdSpacing
        readonly property real defectWidth: (content.width * defectRelWidth) - thirdSpacing
        readonly property real measureWidth: (content.width * measureRelWidth) - thirdSpacing
    }

    ColumnLayout {
        id: content

        anchors {
            top: parent.top
            left: parent.left
            bottom: parent.bottom
            right: actionColumn.left
            margins: Theme.spacingS
        }
        spacing: anchors.margins

        RowLayout {
            spacing: parent.spacing

            Layout.preferredHeight: _.paneHeight

            InfoPane {
                model: root.model

                Layout.preferredWidth: _.infoWidth
                Layout.fillHeight: true
            }

            MeasurementPane {
                model: root.model

                Layout.preferredWidth: _.measureWidth
                Layout.fillHeight: true
            }

            DefectPane {
                model: root.model

                Layout.preferredWidth: _.defectWidth
                Layout.fillHeight: true
            }
        }

        RowLayout {
            spacing: parent.spacing

            Layout.preferredHeight: _.paneHeight

            EventsPane {
                model: root.model

                Layout.preferredWidth: _.paneHalfWidth
                Layout.fillHeight: true
            }

            StatsPane {
                model: root.model

                Layout.preferredWidth: _.paneHalfWidth
                Layout.fillHeight: true
            }
        }
    }

    VCC.WidestItemColumnLayout {
        id: actionColumn

        anchors {
            top: parent.top
            right: parent.right
            bottom: parent.bottom
            margins: content.anchors.margins
        }
        spacing: anchors.margins

        VCB.ActionButton {
            icon.source: "qrc:/resources/icons/export_notes.svg"
            text: qsTr("Export")
            fontColor: Theme.colorOnExport
            backgroundColor: Theme.colorExport

            Layout.fillWidth: true

            onClicked: A.A.ARunExport.view([root.model.id])
        }

        VCB.ActionButton {
            icon.source: "qrc:/resources/icons/spool_reclassify.svg"
            text: qsTr("Reclassify")
            enabled: root.model.classificationDirty
            fontColor: Theme.colorOnAccent
            backgroundColor: Theme.colorAccent

            Layout.fillWidth: true

            onClicked: {
                if (Store.state.nline.state !== L.State.Ready) {
                    A.AAppToast.showInfo(qsTr("The nLine device must be in the 'Ready' state in order to start the reclassification"))
                    return
                }

                A.ARun.startReclassify(root.model.id)
            }
        }

        VCB.ActionButton {
            id: viewProduct

            icon.source: "qrc:/resources/icons/product.svg"
            text: qsTr("View\nproduct")
            visible: false
            fontColor: Theme.colorForeground
            backgroundColor: Theme.colorBackground

            Layout.fillWidth: true

            onClicked: A.AProductDetail.view(root.model.productID)
        }

        Item { Layout.fillHeight: true } // Filler

        VCB.ActionButton {
            icon.source: "qrc:/resources/icons/delete.svg"
            fontColor: Theme.colorForeground
            backgroundColor: Theme.colorBackground

            Layout.fillWidth: true

            onClicked: A.ARun.remove([root.model.id])
        }
    }
}
