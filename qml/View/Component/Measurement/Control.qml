import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Lib as L
import Store
import Theme

import View.Component.Form as VCF

ColumnLayout {
    id: root

    property alias enableMeasurement: enabledSwitch.checked
    property real diameterNorm: 0
    property real diameterUpperDeviation: 0
    property real diameterLowerDeviation: 0
    property real measurementWidth: 0

    spacing: Theme.spacingM

    onDiameterNormChanged: {
        if (_.fromTextEdit) {
            _.fromTextEdit = false
            return
        }
        diameterNormInput.text = L.LMath.roundToFixed(diameterNorm, L.Con.MeasDec)
    }
    onDiameterUpperDeviationChanged: {
        if (_.fromTextEdit) {
            _.fromTextEdit = false
            return
        }
        diameterUpperDeviationInput.text = L.LMath.roundToFixed(diameterUpperDeviation, L.Con.MeasDec)
    }
    onDiameterLowerDeviationChanged: {
        if (_.fromTextEdit) {
            _.fromTextEdit = false
            return
        }
        diameterLowerDeviationInput.text = L.LMath.roundToFixed(diameterLowerDeviation, L.Con.MeasDec)
    }
    onMeasurementWidthChanged: {
        if (_.fromTextEdit) {
            _.fromTextEdit = false
            return
        }
        measurementWidthInput.text = L.LMath.roundToFixed(measurementWidth, L.Con.MeasDec)
    }

    // An input field for the diameter values with a validator for floats 0-1000.
    component DiameterInput: VCF.TextField {
        font.pixelSize: Theme.fontSizeL
        inputMethodHints: Qt.ImhFormattedNumbersOnly
        validator: DoubleValidator {
            bottom: 0
            top: 1000
            decimals: 2
            locale: "en"
        }
    }

    QtObject {
        id: _

        property bool fromTextEdit: false
    }

    RowLayout {
        spacing: Theme.spacingXXL

        VCF.LabeledColumnLayout {
            labelText: qsTr("Active")

            Switch {
                id: enabledSwitch

                text: checked ? qsTr("Yes") : qsTr("No")
            }
        }

        VCF.LabeledColumnLayout {
            //: The target diameter of the product; unit millimeter.
            labelText: qsTr("Target diameter (mm)")
            required: true
            spacing: Theme.spacingXS

            Layout.alignment: Qt.AlignTop

            DiameterInput {
                id: diameterNormInput

                text: L.LMath.roundToFixed(Store.state.productDetail.diameterNorm, L.Con.MeasDec)

                Layout.fillWidth: true

                onTextEdited: {
                    _.fromTextEdit = true
                    root.diameterNorm = acceptableInput ? parseFloat(diameterNormInput.text) : NaN
                }
            }

            VCF.Error {
                text: qsTr("Invalid value")
                visible: !diameterNormInput.acceptableInput

                Layout.fillWidth: true
            }
        }
    }

    // MaxUpperDelta
    ColumnLayout {
        spacing: Theme.spacingS

        VCF.LabeledColumnLayout {
            //: The maximum upper boundary of the diameter deviation; unit millimeter
            labelText: qsTr("Max upper diameter delta (mm)")
            spacing: Theme.spacingXS

            DiameterInput {
                id: diameterUpperDeviationInput

                text: L.LMath.roundToFixed(Store.state.productDetail.diameterUpperDeviation, L.Con.MeasDec)

                Layout.fillWidth: true

                onTextEdited: {
                    _.fromTextEdit = true
                    root.diameterUpperDeviation = acceptableInput ? parseFloat(text) : NaN
                }
            }

            VCF.Error {
                text: qsTr("Invalid value")
                visible: !diameterUpperDeviationInput.acceptableInput

                Layout.fillWidth: true
            }
        }

        Text {
            wrapMode: Text.WordWrap
            text: qsTr("The maximum positive deviation from the target diameter")
            color: enabled ? Theme.colorForeground : Theme.colorForegroundTier3

            Layout.fillWidth: true
        }
    }

    // MaxLowerDelta
    ColumnLayout {
        spacing: Theme.spacingS

        VCF.LabeledColumnLayout {
            //: The maximum lower boundary of the diameter deviation; unit millimeter
            labelText: qsTr("Max lower diameter delta (mm)")
            spacing: Theme.spacingXS

            DiameterInput {
                id: diameterLowerDeviationInput

                text: L.LMath.roundToFixed(Store.state.productDetail.diameterLowerDeviation, L.Con.MeasDec)

                Layout.fillWidth: true

                onTextEdited: {
                    _.fromTextEdit = true
                    root.diameterLowerDeviation = acceptableInput ? parseFloat(text) : NaN
                }
            }

            VCF.Error {
                text: qsTr("Invalid value")
                visible: !diameterLowerDeviationInput.acceptableInput

                Layout.fillWidth: true
            }
        }

        Text {
            wrapMode: Text.WordWrap
            text: qsTr("The maximum negative deviation from the target diameter")
            color: enabled ? Theme.colorForeground : Theme.colorForegroundTier3

            Layout.fillWidth: true
        }
    }

    ColumnLayout {
        spacing: Theme.spacingS

        VCF.LabeledColumnLayout {
            //: The width of the measurement.
            labelText: qsTr("Width (mm)")
            spacing: Theme.spacingXS

            DiameterInput {
                id: measurementWidthInput

                text: L.LMath.roundToFixed(Store.state.productDetail.measurementWidth, L.Con.MeasDec)

                Layout.fillWidth: true

                onTextEdited: {
                    _.fromTextEdit = true
                    root.measurementWidth = acceptableInput ? parseFloat(text) : NaN
                }
            }

            VCF.Error {
                text: qsTr("Invalid value")
                visible: !measurementWidthInput.acceptableInput

                Layout.fillWidth: true
            }
        }

        Text {
            wrapMode: Text.WordWrap
            text: qsTr("The width of the measurement. 0 means smallest possible value.")
            color: enabled ? Theme.colorForeground : Theme.colorForegroundTier3

            Layout.fillWidth: true
        }
    }
}
