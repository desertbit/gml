import QtQuick
import QtQuick.Layouts

import Theme

import View.Component.Form as VCF

Item {
    component LabCol: VCF.LabeledColumnLayout {
        label.font {
            pixelSize: Theme.fontSizeM
            weight: Font.DemiBold
        }

        Layout.fillWidth: true
    }
    component LabRow: VCF.LabeledRowLayout {
        label.font {
            pixelSize: Theme.fontSizeM
            weight: Font.DemiBold
        }
    }
    component Label: Text {
        font.pixelSize: Theme.fontSizeM
    }
}
