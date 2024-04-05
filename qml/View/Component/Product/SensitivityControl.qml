import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Lib as L
import Theme

import View.Component.ComboBox as VCC
import View.Component.Form as VCF
import View.Component.Icon as VCI
import View.Component.Image as VCImg

ColumnLayout {
    id: root

    // The selected preset.
    property int preset: L.Con.SensitivityPreset.Moderate
    // The sensitivity value, if a custom preset is selected.
    property int sensitivity: 0
    // The minimum diameter value, if a custom preset is selected.
    property real minDiameter: 0

    property alias customColumnSpacing: customColumn.spacing
    property alias presetRowChildren: presetRow.children

    readonly property bool valid: minDiameterInput.acceptableInput && sensitivityInput.acceptableInput

    // Loads the currently set property values into the form elements.
    // Must be called when the root properties change and the controls should refresh.
    function loadCurrentValuesIntoForm() {
        presetComboBox.setCurrentIndex(presetComboBox.indexOfValue(preset))
        sensitivityInput.text = sensitivity
        sensitivitySlider.value = sensitivity
        minDiameterInput.text = minDiameter
    }

    spacing: Theme.spacingM

    states: [
        State {
            name: "custom"
            when: root.preset === L.Con.SensitivityPreset.Custom
            PropertyChanges { target: customColumn; visible: true }
        }
    ]

    QtObject {
        id: _

        readonly property int sensitivityMin: 1
        readonly property int sensitivityMax: 100

        readonly property int diameterMin: 0
        readonly property int diameterMax: 500
    }

    RowLayout {
        spacing: Theme.spacingS

        Layout.alignment: Qt.AlignTop

        Text {
            font {
                pixelSize: Theme.fontSizeM
                weight: Font.DemiBold
            }
            text: qsTr("Preset")
        }

        VCC.ComboBox {
            id: presetComboBox

            function _elem(value) {
                return { text: L.Tr.sensitivityPreset(value), value: value }
            }

            textRole: "text"
            valueRole: "value"
            model: [
                _elem(L.Con.SensitivityPreset.Highest),
                _elem(L.Con.SensitivityPreset.High),
                _elem(L.Con.SensitivityPreset.Moderate),
                _elem(L.Con.SensitivityPreset.Low),
                _elem(L.Con.SensitivityPreset.Lowest),
                _elem(L.Con.SensitivityPreset.Custom)
            ]

            onActivated: root.preset = currentValue
        }

        RowLayout {
            id: presetRow

            spacing: Theme.spacingXXS
        }
    }

    ColumnLayout {
        id: customColumn

        spacing: Theme.spacingL
        visible: false

        // MinDiameter column
        ColumnLayout {
            spacing: Theme.spacingS

            VCF.LabeledColumnLayout {
                //: Abbreviation represents millimeter.
                labelText: qsTr("Min. error size (%L1-%L2mm)").arg(_.diameterMin).arg(_.diameterMax)
                spacing: Theme.spacingXS

                VCF.TextField {
                    id: minDiameterInput

                    selectAllOnFocus: true
                    placeholderText: qsTr("Enter size") + "..."
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    validator: DoubleValidator {
                        id: minDiameterValid

                        bottom: _.diameterMin
                        top: _.diameterMax
                        decimals: 2
                        notation: DoubleValidator.StandardNotation
                        locale: "en"
                    }

                    Layout.fillWidth: true

                    onTextChanged: {
                        if (acceptableInput) {
                            root.minDiameter = parseFloat(text)
                        }
                    }
                }

                // Error message.
                VCF.Error {
                    visible: !minDiameterInput.acceptableInput
                    text: qsTr("Invalid value")
                }
            }

            // Info message.
            Text {
                wrapMode: Text.WordWrap
                text: qsTr("The minimum error size will filter out errors that are smaller than the configured size.")

                Layout.fillWidth: true
            }
        }

        // Sensitivity column
        VCF.LabeledColumnLayout {
            labelText: qsTr("Sensitivity (%L1-%L2%)").arg(_.sensitivityMin).arg(_.sensitivityMax)
            spacing: Theme.spacingXS

            RowLayout {
                spacing: Theme.spacingS

                VCF.TextField {
                    id: sensitivityInput

                    placeholderText: qsTr("Sensitivity...")
                    selectAllOnFocus: true
                    inputMethodHints: Qt.ImhDigitsOnly
                    validator: IntValidator {
                        bottom: _.sensitivityMin
                        top: _.sensitivityMax
                    }

                    onTextChanged: {
                        if (acceptableInput && focus) {
                            // Adjust the slider.
                            sensitivitySlider.value = parseInt(text)
                            // Invert the value as the backend interprets it the other way round.
                            root.sensitivity = sensitivitySlider.value
                        }
                    }

                    Layout.preferredWidth: 60
                }

                Slider {
                    id: sensitivitySlider

                    from: _.sensitivityMin
                    to: _.sensitivityMax
                    stepSize: 1
                    live: true
                    snapMode: Slider.SnapAlways

                    Layout.fillWidth: true
                    Layout.topMargin: Theme.spacingS

                    onMoved: {
                        root.sensitivity = value
                        sensitivityInput.text = value
                    }

                    Label {
                        // Positions the label like the handle.
                        anchors {
                            horizontalCenter: parent.handle.horizontalCenter
                            bottom: parent.handle.top
                            bottomMargin: Theme.spacingXXS
                        }
                        text: sensitivitySlider.value
                    }
                }
            }

            // Error message.
            VCF.Error {
                visible: !sensitivityInput.acceptableInput
                text: qsTr("Invalid value")

                Layout.bottomMargin: Theme.spacingXS
            }

            // Info message.
            Text {
                wrapMode: Text.WordWrap
                text: qsTr("A higher sensitivity will detect more defects, because nLine will be more sensitive towards errors.")

                Layout.fillWidth: true
            }

            // Color Scale
            ColumnLayout {
                spacing: Theme.spacingXXS

                Layout.fillWidth: true

                VCImg.Image {
                    cache: false
                    source: "qrc:/resources/images/colorscale_jet"
                    fillMode: Image.PreserveAspectCrop

                    Layout.preferredHeight: 30
                    Layout.rightMargin: Theme.spacingXXS
                    Layout.leftMargin: Theme.spacingXXS
                    Layout.fillWidth: true

                    // Interactive overlay for the image to represent the slider's value.
                    Rectangle {
                        anchors{
                            top: parent.top
                            right: parent.right
                            bottom: parent.bottom
                        }
                        // Overlay needs to be as wide as the right side of the "unselected" slider range.
                        width: parent.width * (1 - (sensitivitySlider.value / _.sensitivityMax))
                        height: parent.height
                        opacity: 0.75
                        color: Theme.colorBackgroundTier2
                    }
                }

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        font.pixelSize: Theme.fontSizeM
                        text: qsTr("Severe")
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        font.pixelSize: Theme.fontSizeM
                        text: qsTr("Minor")
                    }
                }
            }

            // Warn message for sensitivities below minimum.
            RowLayout {
                readonly property bool tooLow: sensitivitySlider.value < L.Con.MinRecommendedSensitivity
                readonly property bool tooHigh: sensitivitySlider.value > L.Con.MaxRecommendedSensitivity


                spacing: Theme.spacingXS
                visible: tooLow || tooHigh

                VCI.Icon {
                    name: "alert-triangle"
                    color: Material.color(Material.Orange)
                    size: Theme.fontSizeXL

                    Layout.alignment: Qt.AlignCenter
                }

                Text {
                    font {
                        pixelSize: Theme.fontSizeM
                        weight: Font.DemiBold
                    }
                    wrapMode: Text.WordWrap
                    text: parent.tooLow ? qsTr("Lower sensitivities may result in no defects being found at all.")
                                        : qsTr("Higher sensitivities may result in too many defects being found.")


                    Layout.fillWidth: true
                }
            }
        }
    }
}
