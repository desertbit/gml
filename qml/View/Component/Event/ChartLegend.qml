import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCharts
import Action as A
import Lib as L
import Theme

RowLayout {
    id: root

    property var codes: L.Event.Codes

    spacing: Theme.spacingM

    Repeater {
        model: root.codes

        Row {
            spacing: Theme.spacingXXS

            Rectangle {
                id: indicator

                anchors.verticalCenter: parent.verticalCenter
                height: label.font.pixelSize
                width: height
                radius: height
                color: L.Event.codeColor(modelData)
            }

            Text {
                id: label

                anchors.verticalCenter: parent.verticalCenter
                text: L.Event.codeName(modelData)
                font.pixelSize: Theme.fontSizeM
            }
        }
    }
}

