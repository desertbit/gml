import QtCharts as QC
import Action as A
import Lib as L

QC.ScatterSeries {
    property int code
    property real size: 10

    color: L.Event.codeColor(code)
    visible: count > 0
    markerSize: size
}
