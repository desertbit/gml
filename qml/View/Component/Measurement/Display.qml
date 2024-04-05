import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Lib as L
import Store
import Theme

import View.Component.Container as VCC
import View.Component.Form as VCF
import View.Component.Icon as VCI
import View.Component.Text as VCT

import ".." // Components

ColumnLayout {
    id: root

    property bool enableMeasurement: false
    property real diameterNorm: 0
    property real diameterUpperDeviation: 0
    property real diameterLowerDeviation: 0
    property real measurementWidth: 0

    spacing: Theme.spacingS

    RowLayout {
        spacing: Theme.spacingXXL

        VCF.LabeledColumnLayout {
            labelText: qsTr("Active")

            VCT.ActiveIcon {
                state: root.enableMeasurement ? "" : "inactive"
            }
        }

        VCF.LabeledRowLayout {
            //: The target diameter of the product; unit millimeter.
            labelText: qsTr("Target diameter (mm)")

            Layout.alignment: Qt.AlignTop

            Text {
                font.pixelSize: Theme.fontSizeL
                text: L.LMath.roundToFixed(root.diameterNorm, L.Con.MeasDec)
            }
        }
    }

    VCF.LabeledRowLayout {
        //: The maximum upper boundary of the diameter deviation; unit millimeter
        labelText: qsTr("Max upper diameter delta (mm)")

        Text {
            font.pixelSize: Theme.fontSizeL
            text: L.LMath.roundToFixed(root.diameterUpperDeviation, L.Con.MeasDec)
        }
    }

    VCT.Info {
        text: qsTr("The maximum positive deviation from the target diameter")

        Layout.bottomMargin: Theme.spacingXS
    }

    VCF.LabeledRowLayout {
        //: The maximum lower boundary of the diameter deviation; unit millimeter
        labelText: qsTr("Max lower diameter delta (mm)")

        Text {
            font.pixelSize: Theme.fontSizeL
            text: L.LMath.roundToFixed(root.diameterLowerDeviation, L.Con.MeasDec)
        }
    }

    VCT.Info {
        text: qsTr("The maximum negative deviation from the target diameter")

        Layout.bottomMargin: Theme.spacingXS
    }

    VCF.LabeledRowLayout {
        //: The width of the measurement.
        labelText: qsTr("Width (mm)")

        Text {
            font.pixelSize: Theme.fontSizeL
            text: L.LMath.roundToFixed(root.measurementWidth, L.Con.MeasDec)
        }
    }

    VCT.Info {
        text: qsTr("The width of the measuring point. 0 means smallest possible value.")
    }
}
