import QtQuick as Quick
import QtQuick.Layouts

import Theme

import View.Component.Form as VCF

GridLayout {
    id: root

    columns: 2
    columnSpacing: 6

    Layout.alignment: Qt.AlignTop
    
    component Label: Quick.Text {
        font {
            pixelSize: Theme.fontSizeM
            weight: Quick.Font.DemiBold
        }
    }
    component Text: Quick.Text { font.pixelSize: Theme.fontSizeL }
    component HorDivider: VCF.HorDivider { Layout.columnSpan: parent.columns; Layout.margins: 2 }
    component VerDivider: VCF.VerDivider { Layout.fillHeight: false; Layout.margins: 0; implicitHeight: parent.implicitHeight }
}
