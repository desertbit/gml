import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

import Action as A
import Lib as L
import Theme
import Store

import View.Component.Button as VCB
import View.Component.Camera as VCCam
import View.Component.Container as VCC
import View.Component.Image as VCImg
import View.Component.Text as VCT

import "Component"

VCC.Page {
    id: root

    title: _.title

    states: [
        State {
            name: "loading"
            when: Store.view.pdfPreviewLoading
            PropertyChanges { target: progress; visible: true }
            PropertyChanges { target: content; visible: false }
        }
    ]

    QtObject {
        id: _

        readonly property string title: {
            let title = qsTr("PDF preview")
            if (Store.state.runExport.skippedRunDetail) {
                return title
            }
            if (Store.state.pdfPreview.resourceID > 0) {
                return `${title} - ${L.Tr.resource(Store.state.pdfPreview.resourceID)}`
            }
            if (Store.state.pdfPreview.runID > 0) {
                return `${title} - ` + qsTr("Batch") + ` ${Store.state.runExport.runs.find(r => r.id === Store.state.pdfPreview.runID).name}`
            }
            return ""
        }

        property int page: 0

        // When the page is negative, the pdf does show no page, which is what we want
        // to achieve the real book-like experience.
        readonly property int leftPage: page - 1
        readonly property int rightPage: page < Store.state.pdfPreview.numPages ? page : -1

        readonly property bool atStart: page === 0
        readonly property bool atEnd: page === Store.state.pdfPreview.numPages - 1

        readonly property int numPagesNavigation: 2
        readonly property int numPagesFastNavigation: 6
    }

    ColumnLayout {
        id: progress

        anchors.centerIn: parent
        visible: false
        spacing: Theme.spacingXS

        Text {
            font {
                pixelSize: Theme.fontSizeXL
                italic: true
            }
            text: qsTr("Loading...")

            Layout.alignment: Qt.AlignHCenter
        }

        ProgressBar {
            value: Store.state.pdfPreview.progress
            indeterminate: Store.state.pdfPreview.progress === -1

            Layout.preferredWidth: 600
        }
    }

    RowLayout {
        id: content

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            bottom: parent.bottom
            margins: Theme.spacingXS
        }
        spacing: Theme.spacingXS

        VCB.RoundIconButton {
            highlighted: true
            fontIcon {
                id: skipBackIcon

                name: "fast-forward"
                color: Theme.colorOnAccent
                transform: Rotation {
                    angle: 180
                    origin {
                        x: skipBackIcon.width/2
                        y: skipBackIcon.height/2
                    }
                }
            }
            enabled: !_.atStart

            onClicked: _.page = Math.max(0, _.page - _.numPagesFastNavigation)
        }

        VCB.RoundIconButton {
            enabled: !_.atStart
            highlighted: true
            fontIcon {
                color: Theme.colorOnAccent
                name: "arrow-left"
            }

            onClicked: _.page -= _.numPagesNavigation
        }

        // The pdf pages.
        RowLayout {
            spacing: 2

            PDFPage {
                page: _.leftPage

                Layout.fillHeight: true
            }

            PDFPage {
                page: _.rightPage

                Layout.fillHeight: true
            }
        }

        VCB.RoundIconButton {
            enabled: !_.atEnd
            highlighted: true
            fontIcon {
                color: Theme.colorOnAccent
                name: "arrow-right"
            }

            onClicked: _.page += _.numPagesNavigation
        }

        VCB.RoundIconButton {
            enabled: !_.atEnd
            highlighted: true
            fontIcon {
                name: "fast-forward"
                color: Theme.colorOnAccent
            }

            onClicked: _.page = Math.min(Store.state.pdfPreview.numPages, _.page + _.numPagesFastNavigation)
        }
    }
}
