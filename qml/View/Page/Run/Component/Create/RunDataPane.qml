import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action.RunCreate as ARunCreate

import Lib as L
import Store
import Theme

import View.Component.Button as VCB
import View.Component.Container as VCC
import View.Component.Form as VCF
import View.Component.Image as VCI

VCC.TickIconPane {
    id: root

    property alias name: name.text
    // The UI shows speed as m/min, but when sent to the backend, it must be cm/min
    property real speed: parseFloat(speedInput.text) * 100 || 0
    property alias defaultSpeed: speedInput.text

    // Emitted when the user presses the load defaults button.
    signal loadDefaults()

    titleText: "4. " + qsTr("Batch data")
    contentSpacing: Theme.spacingL

    states: [
        State {
            name: "valid"
            extend: "ticked"
            when: root.name !== "" && err.text === "" && speedInput.acceptableInput
        }
    ]

    VCF.LabeledColumnLayout {
        labelText: qsTr("BatchID")
        required: true

        VCF.TextField {
            id: name

            placeholderText: qsTr("Batch identifier") + "..."
            maximumLength: L.Val.RunNameMaxLen

            Layout.fillWidth: true

            // Jump to the next input field when the return key is pressed.
            Keys.onReturnPressed: speedInput.forceActiveFocus()
        }

        RowLayout {
            spacing: Theme.spacingXXS

            VCF.Error {
                id: err

                text: L.Val.runName(root.name, true)
                wrapMode: Text.WordWrap
                visible: true // Needed to push button to the right side.

                Layout.fillWidth: true
            }

            VCB.Button {
                highlighted: name.text === ""
                text: qsTr("Generate")

                onClicked: ARunCreate.generateUniqueRunName().then((data) => name.text = data.name)
            }
        }
    }

    VCF.LabeledColumnLayout {
        //: Abbreviation for meter per minute.
        labelText: qsTr("Speed (m/min)")
        required: true

        Layout.bottomMargin: Theme.spacingS

        VCF.TextField {
            id: speedInput

            placeholderText: qsTr("Production speed") + "..."
            selectAllOnFocus: true
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            validator: DoubleValidator {
                id: speedValid

                bottom: L.LMath.roundToFixed(Store.state.nline.speedLimit.min/100, 2)
                top: L.LMath.roundToFixed(Store.state.nline.speedLimit.max/100, 2)
                decimals: 2
                notation: DoubleValidator.StandardNotation
                locale: "en"
            }

            Layout.fillWidth: true

            // Close the keyboard when the return key is pressed.
            Keys.onReturnPressed: focus = false
        }

        VCF.Error {
            text: qsTr("Invalid value (%L1 - %L2 allowed)").arg(speedValid.bottom).arg(speedValid.top)
            visible: !speedInput.acceptableInput && enabled && speedInput.text !== ""

            Layout.fillWidth: true
        }
    }

    RowLayout {
        VCB.Button {
            text: qsTr("Load defaults")
            
            onClicked: root.loadDefaults()
        }
    }
}
