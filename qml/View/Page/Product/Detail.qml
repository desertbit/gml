import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action.CameraFocus as ACameraFocus
import Action.ClassificationImageOverview as AClassificationImageOverview
import Action.Product as AProduct
import Action.ProductDetail as AProductDetail
import Action.ProductRetrain as AProductRetrain
import Action.ProductTrainImages as AProductTrainImages
import Action.RunCreate as ARunCreate

import Lib as L
import Store
import Theme

import View.Component.Button as VCB
import View.Component.Container as VCC
import View.Component.Form as VCF

import "Component/Detail"

VCC.Page {
    id: root

    title: Store.state.productDetail.name || Store.state.productDetail.id

    QtObject {
        id: _

        readonly property real infoRelWidth: 0.35
        readonly property real defectRelWidth: 0.35
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
                Layout.preferredWidth: _.infoWidth
                Layout.fillHeight: true
            }

            DefectPane {
                Layout.preferredWidth: _.defectWidth
                Layout.fillHeight: true
            }

            MeasurementPane {
                Layout.preferredWidth: _.measureWidth
                Layout.fillHeight: true
            }
        }

        RowLayout {
            spacing: parent.spacing

            Layout.preferredHeight: _.paneHeight

            RunsPane {
                Layout.preferredWidth: _.paneHalfWidth
                Layout.fillHeight: true
            }

            StatsPane {
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
            icon.source: "qrc:/resources/icons/edit.svg"
            text: qsTr("Edit")
            fontColor: Theme.colorForeground
            backgroundColor: Theme.colorBackground

            onClicked: AProductDetail.edit()
        }

        VCB.ActionButton {
            readonly property bool updateAvailable: Store.state.productDetail.updateAvailable

            icon.source: "qrc:/resources/icons/product_retrain.svg"
            text: updateAvailable ? qsTr("Update") : qsTr("Retrain")
            fontColor: updateAvailable ? Theme.colorOnAccent : Theme.colorForeground
            backgroundColor: updateAvailable ? Theme.colorAccent : Theme.colorBackground

            onClicked: AProductRetrain.view(Store.state.productDetail.id)
        }

        VCB.ActionButton {
            icon.source: "qrc:/resources/icons/spool_reclassify.svg"
            text: qsTr("Reclassify\nbatches")
            fontColor: Theme.colorOnAccent
            backgroundColor: Theme.colorAccent
            enabled: Store.state.productDetail.hasRunWithDirtyClassification

            onClicked: AProductDetail.startReclassifyAllRuns(Store.state.productDetail.id)
        }

        VCB.ActionButton {
            icon.source: "qrc:/resources/icons/spool_new.svg"
            text: qsTr("New\nbatch")
            fontColor: Theme.colorForeground
            backgroundColor: Theme.colorBackground

            onClicked: ARunCreate.viewFromProductDetail(Store.state.productDetail.id)
        }

        VCB.ActionButton {
            icon.source: "qrc:/resources/icons/image.svg"
            //: Images to train an AI model.
            text: qsTr("Train\nimages")
            fontColor: Theme.colorForeground
            backgroundColor: Theme.colorBackground

            onClicked: AProductTrainImages.view(Store.state.productDetail.id)
        }

        VCB.ActionButton {
            icon.source: "qrc:/resources/icons/classification_image.svg"
            //: Images that contain classification labels to train a classification AI model.
            text: qsTr("Classification\nimages")
            fontColor: Theme.colorForeground
            backgroundColor: Theme.colorBackground

            onClicked: AClassificationImageOverview.view(Store.state.productDetail.id)
        }

        VCB.ActionButton {
            icon.source: "qrc:/resources/icons/camera_settings.svg"
            text: qsTr("Camera\nsettings")
            fontColor: Theme.colorForeground
            backgroundColor: Theme.colorBackground
            visible: Store.state.nline.hasMotorizedFocus

            onClicked: ACameraFocus.viewFromProductDetail(Store.state.productDetail.id)
        }

        Item { Layout.fillHeight: true } // Filler

        VCB.ActionButton {
            icon.source: "qrc:/resources/icons/delete.svg"
            fontColor: Theme.colorForeground
            backgroundColor: Theme.colorBackground

            onClicked: AProduct.remove(Store.state.productDetail.id)
        }
    }
}
