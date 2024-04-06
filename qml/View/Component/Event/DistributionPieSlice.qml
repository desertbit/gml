import QtQuick
import QtCharts
import Action as A
import Lib as L
import Theme

PieSlice {
    required property int code

    label: `${(percentage*100).toFixed(2)}%`
    color: L.Event.codeColor(code)
    labelVisible: true
    labelPosition: PieSlice.LabelInsideHorizontal
    labelFont {
        pixelSize: Theme.fontSizeS
        weight: Font.DemiBold
    }
    labelColor: "white"
}
