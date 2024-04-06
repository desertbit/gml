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
import View.Component.Form as VCF
import View.Component.Handler as VCH

import "classSelect.js" as Logic

VCC.Pane {
    id: root

    // The currently selected classes.
    readonly property var currentClassIDs: _.currentClassIDs
    // True, if all classes are selected.
    readonly property bool allSelected: currentClassIDs.length === Store.state.anomalyClasses.length

    // Keep in sync with the given property, if set.
    // This causes the ClassSelect to always follow the value of this state.
    property var syncTo: undefined
    onSyncToChanged: {
        if (syncTo === undefined) {
            return
        }
        if (syncTo === null) {
            // Null is a special case, that is used inside the store to represent that the 
            // anomaly classes filter is currently not in use.
            // When loading this value, simply deselect all classes instead.
            selectClasses([])
        } else {
            selectClasses(syncTo)
        }
    }

    // Emitted, when the user clicks on the apply button to confirm the currently selected codes.
    signal selected()

    // selectClasses checks all Checkboxes matching the given ids.
    // currentClassIDs is after this method finished equal to the given class ids.
    function selectClasses(classIDs) {
        Logic.loadClassIDsIntoCheckBoxes(classIDs)
        _.currentClassIDs = classIDs
    }

    // selectAll selects all anomaly classes.
    function selectAll() {
        selectClasses(Store.state.anomalyClasses.map(c => c.id))
    }

    // isSelectionEqual returns true, if the given classes array is equal to the currently selected classes.
    function isSelectionEqual(classes) {
        return currentClassIDs.length === classes.length &&
               currentClassIDs.every((value, index) => value === classes[index])
    }

    contentWidth: content.implicitWidth
    contentHeight: content.implicitHeight
    hoverEnabled: true
    backgroundShadow.color: root.hovered ? Material.color(Material.Grey, Material.Shade100) : root.Material.backgroundColor

    // Initialize with synced state.
    Component.onCompleted: {
        if (syncTo !== undefined) {
            root.syncToChanged()
        }
    }

    QtObject {
        id: _

        // Do not modify this directly, use methods.
        property var currentClassIDs: []

        // The maximum number of classes shown before truncation.
        readonly property int maxClassesShown: 10

        function syncToCheckBoxes() {
            currentClassIDs = Logic.readClassIDsFromCheckBoxes()
        }
    }

    VCH.Tap {
        enabled: root.enabled
        margin: root.padding

        onTapped: popup.open()
    }

    // The main content that shows a colored circle for each selected class.
    RowLayout {
        id: content

        Repeater {
            // Retrieve the anomaly classes that are currently selected,
            // but no more than our limit.
            model: Store.view.anomalyClassesByIDs(_.currentClassIDs.slice(0, _.maxClassesShown))

            Rectangle {
                width: 15
                height: width
                radius: width/2
                color: modelData.color
                border {
                    width: 1
                    color: "black"
                }
                visible: !root.allSelected
            }
        }

        Text {
            text: "..."
            visible: !root.allSelected && _.currentClassIDs.length > _.maxClassesShown
            height: 15
        }

        Text {
            text: qsTr("All classes")
            font.weight: Font.DemiBold
            visible: root.allSelected
            height: 15
        }

        Text {
            text: qsTr("No Classes")
            font.weight: Font.DemiBold
            visible: _.currentClassIDs.empty()
            height: 15
        }
    }

    Rectangle {
        color: "#6FEEEEEE"
        anchors.fill: parent
        radius: root.background.radius
        visible: !root.enabled
    }

    // This popup displays the Checkboxes the user can interact with.
    Popup {
        id: popup

        x: -leftPadding
        y: -root.topPadding

        // Reset the checkbox state to the current classes.
        onAboutToShow: root.selectClasses(_.currentClassIDs)
        // Reset the checkbox state to the current classes.
        onClosed: root.selectClasses(_.currentClassIDs)

        ColumnLayout {
            id: popupContent

            anchors.fill: parent

            // This ButtonGroup allows the all Checkbox to select/deselect all other Checkboxes.
            ButtonGroup {
                id: allGroup

                exclusive: false
                checkState: all.checkState
            }

            RowLayout {
                CheckBox {
                    id: all

                    checkState: allGroup.checkState
                    text: qsTr("All")

                    Material.accent: "black"
                    Layout.fillWidth: true
                }

                VCB.Button {
                    text: qsTr("Apply")
                    highlighted: true
                    flat: true

                    onClicked: {
                        _.syncToCheckBoxes()
                        root.selected()
                        popup.close()
                    }
                }
            }

            VCF.HorDivider {}

            GridLayout {
                id: checkboxGrid

                columns: 3
                columnSpacing: parent.spacing
                rowSpacing: parent.spacing

                Repeater {
                    model: Store.state.anomalyClasses

                    CheckBox {
                        readonly property int classID: modelData.id

                        // Class with ID 1 is the static "No Error" class.
                        text: L.Tr.anomalyClass(classID, modelData.name)
                        leftPadding: 1.5*indicator.width

                        ButtonGroup.group: allGroup
                        Material.accent: modelData.color
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }
}
