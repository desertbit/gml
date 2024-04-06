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
import View.Component.Container as VCC
import View.Component.Image as VCImg
import View.Component.List as VCL

import "detail.js" as Logic

VCC.Page {
    id: root

    title: (Store.state.classificationImageDetail.fromEvent ? `${qsTr("Classification image")} - ` : "") + Store.state.classificationImageDetail.id
    hasUnsavedChanges: state === "edit" && edit.enabled

    states: [
        State {
            name: "edit"
            PropertyChanges {
                target: edit
                text: qsTr("Save")
                enabled: !_.noClassesSet
                onClicked: Logic.save()
            }
            PropertyChanges { target: editCancel; visible: true }
            PropertyChanges { target: showBoxes; checked: true }
            PropertyChanges { target: _; boxToClassMapping: ({}) } // This resets the box classes automatically.
        }
    ]

    QtObject {
        id: _

        // Mapping of anomalyBoxID to anomalyClassID, which represents custom classes
        // that the user has chosen for certain boxes.
        property var boxToClassMapping: ({})

        // True, when all anomaly boxes have no class assigned to them.
        readonly property bool noClassesSet: Store.state.classificationImageDetail.anomalyBoxes.every(ab => 
            (!_.boxToClassMapping.hasOwnProperty(ab.id) && ab.anomalyClassID === L.Con.AnomalyClass.Unclassified) || 
            (_.boxToClassMapping.hasOwnProperty(ab.id) && _.boxToClassMapping[ab.id] === L.Con.AnomalyClass.Unclassified)
        )
    }

    VCA.SelectionDialog {
        id: selectClassDialog

        property int boxID: 0

        anchors.centerIn: Overlay.overlay
        modal: true
        description: qsTr("Select the class that applies to this defect.")
        max: 1

        onSaved: classIDs => Logic.updateBoxToClassMapping(boxID, classIDs)
    }

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
                checked: true
            }

            // Switch selection for box visualization.
            Switch {
                id: showBoxes

                text: qsTr("Show Boxes")
                font.pixelSize: Theme.fontSizeL
                topPadding: 0
                bottomPadding: 0
                checked: true
            }

            VCB.Button {
                id: edit

                text: qsTr("Edit")
                highlighted: true

                Layout.leftMargin: Theme.spacingM

                onClicked: root.state = "edit"
            }

            VCB.Button {
                id: editCancel

                text: qsTr("Cancel")
                visible: false

                onClicked: root.state = ""
            }

            Item { Layout.fillWidth: true } // Filler

            VCB.Button {
                text: qsTr("Anomaly classes")

                onClicked: A.AAnomalyClass.view()
            }

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
                spacing: Theme.spacingL
                visible: !Store.state.classificationImageDetail.fromEvent

                VCB.RoundIconButton {
                    highlighted: true
                    enabled: Store.state.classificationImageDetail.hasPrev
                    fontIcon {
                        color: Theme.colorOnAccent
                        name: "arrow-left"
                    }

                    onClicked: A.A.AClassificationImageDetail.viewPrev()
                }

                VCB.RoundIconButton {
                    highlighted: true
                    enabled: Store.state.classificationImageDetail.hasNext
                    fontIcon {
                        color: Theme.colorOnAccent
                        name: "arrow-right"
                    }

                    onClicked: A.A.AClassificationImageDetail.viewNext()
                }
            }

            VCB.RoundIconButton {
                fontIcon {
                    name: "trash-2"
                    color: Theme.colorForeground
                }
                flat: true

                onClicked: A.AClassificationImage.remove(Store.state.classificationImageDetail.productID, [Store.state.classificationImageDetail.id])
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
                    Store.state.classificationImageDetail.imageDefectSource : 
                    Store.state.classificationImageDetail.imageSource

        onSingleTapped: {
            // This enables the user to click anywhere on the image and cycle through
            // the possible display options.
            if (showDefect.enabled) {
                showDefect.toggle()
            }
        }

        Repeater {
            model: Store.state.classificationImageDetail.anomalyBoxes

            VCABox.Delegate {
                imageX: img.imageX
                imageY: img.imageY
                imageWidth: img.imageWidth
                imageHeight: img.imageHeight
                visible: showBoxes.checked
                assignClassVisible: root.state === "edit"
                customAnomalyClass: {
                    if (_.boxToClassMapping.hasOwnProperty(modelData.id)) {
                        const classID = _.boxToClassMapping[modelData.id]
                        if (classID === L.Con.AnomalyClass.Unclassified) {
                            return { id: L.Con.AnomalyClass.Unclassified }
                        }
                        return Store.state.anomalyClasses.find(ac => ac.id === classID)
                    }
                    return null
                }

                onClassAssign: {
                    selectClassDialog.boxID = modelData.id
                    const classID = customAnomalyClass ? customAnomalyClass.id : modelData.anomalyClassID
                    selectClassDialog.show(classID > L.Con.AnomalyClass.Unclassified ? [classID] : [])
                }
            }
        }
    }

    Label {
        anchors {
            top: img.top
            right: img.right
            margins: Theme.spacingS
        }
        text: Store.state.classificationImageDetail.created.formatDateTime(Store.state.locale)
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
}
