import QtQuick
import QtCharts

import Lib as L
import Theme

BarSet {
    required property int code
    required property int value

    label: `${L.Event.codeName(code)} - ${value}`
    color: L.Event.codeColor(code)
    values: [value]
    labelFont {
        pixelSize: Theme.fontSizeS
        weight: Font.DemiBold
    }
}
