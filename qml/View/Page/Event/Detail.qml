import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action as A
import Lib as L
import Store
import Theme

import View.Component.AnomalyBox as VCABox
import View.Component.AnomalyClass as VCA
import View.Component.Button as VCB
import View.Component.ComboBox as VCCombo
import View.Component.Container as VCC
import View.Component.Date as VCD
import View.Component.Event as VCE
import View.Component.Form as VCF
import View.Component.Image as VCImg
import View.Component.List as VCL

VCC.Page {
    id: root

    title: (Store.state.eventDetail.skippedOverview ? `${qsTr("Event")} - ` : "") + Store.state.eventDetail.num

    states: [
        State {
            name: "hasClassificationImage"
            when: Store.state.eventDetail.usedAsCustomTrainImage
            PropertyChanges { 
                target: classification
                text: qsTr("View classification image") 
                highlighted: false
                onClicked: A.AClassificationImageDetail.viewFromEvent(Store.state.eventDetail.id)
            }
        }
    ]

    VCL.HeaderBar {
        id: bar

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        RowLayout {
            anchors.fill: parent
            spacing: Theme.spacingS

            // Switch selection for defect visualization.
            Switch {
                id: showDefect

                text: qsTr("Show Defect")
                font.pixelSize: Theme.fontSizeL
                topPadding: 0
                bottomPadding: 0
                enabled: Store.state.eventDetail.code === L.Event.Code.Defect
                checked: enabled

                onToggled: {
                    if (checked) {
                        showMeasurement.checked = false
                    }
                }
            }

            // Switch selection for box visualization.
            Switch {
                id: showBoxes

                text: qsTr("Show Boxes")
                font.pixelSize: Theme.fontSizeL
                topPadding: 0
                bottomPadding: 0
                enabled: Store.state.eventDetail.code === L.Event.Code.Defect
                checked: enabled
            }

            // Switch selection for measurement visualization.
            Switch {
                id: showMeasurement

                text: qsTr("Show Measurement")
                font.pixelSize: Theme.fontSizeL
                topPadding: 0
                bottomPadding: 0
                enabled: (Store.state.eventDetail.code === L.Event.Code.Defect || Store.state.eventDetail.code === L.Event.Code.MeasureDrift) && Store.state.eventDetail.hasMeasurement
                checked: Store.state.eventDetail.code === L.Event.Code.MeasureDrift && Store.state.eventDetail.hasMeasurement

                onToggled: {
                    if (checked) {
                        showDefect.checked = false
                    }
                }
            }

            VCB.Button {
                id: classification

                text: qsTr("Create classification image")
                highlighted: true
                visible: Store.state.eventDetail.code === L.Event.Code.Defect

                Layout.leftMargin: Theme.spacingM

                onClicked: {
                    if (!Store.state.eventDetail.classifiable) {
                        A.AAppToast.showWarning(qsTr("This event has been created before the classification update.\nIt can not be classified."))
                        return
                    }

                    const boxToClassMapping = {}
                    Store.state.eventDetail.anomalyBoxes.forEach(ab => {
                        if (ab.anomalyClassID !== L.Con.AnomalyClass.Unclassified) {
                            boxToClassMapping[ab.id] = ab.anomalyClassID
                        }
                    })
                    A.AClassificationImageCreate.view(Store.state.eventDetail.id, Store.state.eventDetail.productID)
                }
            }

            VCB.Button {
                id: classificationCancel

                text: qsTr("Cancel")
                visible: false

                onClicked: root.state = ""
            }

            Item { Layout.fillWidth: true } // Filler

            // Zoom options.
            RowLayout {
                readonly property real step: 0.5

                spacing: Theme.spacingS
                Layout.rightMargin: Theme.spacingL

                VCB.Button {
                    text: qsTr("Reset zoom")
                    highlighted: true
                    visible: img.scale > img.minScale

                    onClicked: img.reset()
                }

                VCB.RoundIconButton {
                    fontIcon {
                        name: "zoom-in"
                        color: enabled ? Theme.colorForeground : Theme.colorForegroundTier3
                    }
                    flat: true
                    enabled: img.scale < img.maxScale

                    onClicked: img.zoomCenter(parent.step)
                }

                VCB.RoundIconButton {
                    fontIcon {
                        name: "zoom-out"
                        color: enabled ? Theme.colorForeground : Theme.colorForegroundTier3
                    }
                    flat: true
                    enabled: img.scale > img.minScale

                    onClicked: img.zoomCenter(-parent.step)
                }
            }

            // Page selection.
            Row {
                id: pagination
                spacing: Theme.spacingL

                VCB.RoundIconButton {
                    highlighted: true
                    enabled: Store.state.eventDetail.hasPrev
                    fontIcon {
                        color: Theme.colorOnAccent
                        name: "arrow-left"
                    }

                    onClicked: A.AEventDetail.viewPrev()
                }

                VCB.RoundIconButton {
                    highlighted: true
                    enabled: Store.state.eventDetail.hasNext
                    fontIcon {
                        color: Theme.colorOnAccent
                        name: "arrow-right"
                    }

                    onClicked: A.AEventDetail.viewNext()
                }
            }
        }
    }

    VCImg.FlickableImage {
        id: img

        anchors {
            top: bar.bottom
            right: parent.right
            bottom: parent.bottom
            left: parent.left
        }
        source: showDefect.checked ? 
                    Store.state.eventDetail.imageDefectSource : 
                    showMeasurement.checked ? 
                        Store.state.eventDetail.imageMeasurementSource : 
                        Store.state.eventDetail.imageSource

        onSingleTapped: {
            // This enables the user to click anywhere on the image and cycle through
            // the possible display options.
            if (showDefect.enabled) {
                showDefect.toggle()
            }
        }

        Repeater {
            model: Store.state.eventDetail.anomalyBoxes

            VCABox.Delegate {
                imageX: img.imageX
                imageY: img.imageY
                imageWidth: img.imageWidth
                imageHeight: img.imageHeight
                visible: showBoxes.checked
                assignClassVisible: false
            }
        }
    }

    RowLayout {
        anchors {
            top: img.top
            left: img.left
            right: img.right
            margins: Theme.spacingS
        }
        spacing: Theme.spacingXS

        component InfoLabel: Label {
            color: Theme.colorForeground
            padding: Theme.spacingXXS
            font {
                weight: Font.DemiBold
                pixelSize: Theme.fontSizeM
            }
            background: Rectangle {
                radius: 4
                color: Theme.colorBackground
                opacity: 0.85
            }
        }

        Label {
            background: Rectangle {
                radius: 5
                color: Theme.colorAnomalyClass
            }
            padding: Theme.spacingXXS
            color: Theme.colorOnAnomalyClass
            text: qsTr("Has classification image")
            font {
                pixelSize: Theme.fontSizeM
                weight: Font.DemiBold
            }
            visible: Store.state.eventDetail.usedAsCustomTrainImage
        }

        Item { Layout.fillWidth: true } // Filler

        InfoLabel { text: Store.state.eventDetail.ts.formatDateTime(Store.state.locale) }

        InfoLabel { text: L.Event.codeName(Store.state.eventDetail.code) }

        InfoLabel {
            //: m is the abbreviation for meter
            text: qsTr("%L1 m").arg(L.LMath.roundToFixed(Store.state.eventDetail.position/100, 2))
        }

        InfoLabel {
            text: L.Tr.camPosition(
                Store.state.cameras[Store.state.eventDetail.resultIndex]
                    ? Store.state.cameras[Store.state.eventDetail.resultIndex].position
                    : L.Con.CamPosition.Unknown
            )
        }
    }
}
