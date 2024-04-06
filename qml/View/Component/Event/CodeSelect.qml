import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import Action as A
import Lib as L
import Theme

import View.Component.Container as VCC
import View.Component.Handler as VCH

import "codeSelect.js" as Logic

VCC.Pane {
    id: root

    // The currently selected codes.
    readonly property var currentCodes: _.currentCodes
    // True, if all codes are selected.
    readonly property bool allSelected: all.checkState === Qt.Checked

    // Keep in sync with the given property, if set.
    // This causes the CodeSelect to always follow the value of this state.
    property var syncTo: undefined
    onSyncToChanged: {
        if (syncTo === undefined) {
            return
        }
        selectCodes(syncTo)
    }

    // Emitted, when the user clicks on the apply button to confirm the currently selected codes.
    signal selected()

    // selectCodes checks all Checkboxes for the given codes.
    // currentCodes is after this method finished equal to the given codes.
    function selectCodes(codes) {
        Logic.loadCodesIntoCheckBoxes(codes)
        _.currentCodes = codes
    }

    // selectAll selects all event codes.
    function selectAll() { selectCodes(L.Event.Codes) }

    // isSelectionEqual returns true, if the given codes array is equal to the currently selected codes.
    function isSelectionEqual(codes) {
        return currentCodes.length === codes.length &&
               currentCodes.every((value, index) => value === codes[index])
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

        // Do not modify directly, use methods.
        property var currentCodes: []

        function syncToCheckBoxes() {
            currentCodes = Logic.readCodesFromCheckBoxes()
        }
    }

    VCH.Tap {
        margin: root.padding

        onTapped: popup.open()
    }

    // The main content that shows a colored circle for each event code.
    // If the code is selected, the circle is filled with the event code's color.
    GridLayout {
        id: content

        anchors.fill: parent
        rows: 1

        Repeater {
            model: L.Event.Codes

            Rectangle {
                width: 15
                height: width
                radius: width/2
                color: root.currentCodes.includes(modelData) ? L.Event.codeColor(modelData) : "transparent"
                border {
                    width: 1
                    color: "black"
                }
            }
        }
    }

    // This popup displays the Checkboxes the user can interact with.
    Popup {
        id: popup

        x: -leftPadding
        y: -root.topPadding
        margins: 4

        onAboutToShow: {
            // Reset the checkbox state to the current codes.
            root.selectCodes(root.currentCodes)
        }
        onClosed: {
            // Reset the checkbox state to the current codes.
            root.selectCodes(root.currentCodes)
        }

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

                    onToggled: {
                        if (checkState === Qt.Unchecked) {
                            // Select first checkbox again to ensure at least 1 checkbox is always selected.
                            Logic.forEachCheckbox(box => { box.toggle(); return true } )
                        }
                    }
                }

                Button {
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

            Repeater {
                model: L.Event.Codes

                CheckBox {
                    readonly property int code: modelData

                    text: L.Event.codeName(code)
                    leftPadding: 1.5*indicator.width

                    ButtonGroup.group: allGroup
                    Material.accent: L.Event.codeColor(code)
                    Layout.fillWidth: true

                    onToggled: {
                        if (allGroup.checkState === Qt.Unchecked) {
                            // Ensures that the last checked checkbox can not be deselected.
                            toggle()
                        }
                    }
                }
            }
        }
    }
}
