import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import Action as A
import Lib as L
import Store as S
import Theme

import View.Component.Button as VCB

Rectangle {
    id: root

    required property int index
    required property var modelData

    // If set, the box will display this custom anomaly class instead of the one in its modelData.
    // Must be a Model.AnomalyClass object.
    property var customAnomalyClass: null

    property real imageX: 0
    property real imageY: 0
    property real imageWidth: 0
    property real imageHeight: 0

    // Relative coordinates.
    readonly property real px1: modelData.imageWidth  > 0 ? modelData.x1 / modelData.imageWidth  : 0
    readonly property real py1: modelData.imageHeight > 0 ? modelData.y1 / modelData.imageHeight : 0
    readonly property real px2: modelData.imageWidth  > 0 ? modelData.x2 / modelData.imageWidth  : 0
    readonly property real py2: modelData.imageHeight > 0 ? modelData.y2 / modelData.imageHeight : 0

    property alias assignClassVisible: assignClass.visible

    // Emitted, when the user wants to assign a class to this box.
    signal classAssign()

    x: (px1 * imageWidth) + imageX
    y: (py1 * imageHeight) + imageY
    width: (px2 - px1) * imageWidth
    height: (py2 - py1) * imageHeight
    color: "transparent"
    border {
        width: 3
        color: "black"
    }

    states: [
        State {
            name: "hasClass"
            when: _.anomalyClass.id > 0
            PropertyChanges { target: root; border.color: _.anomalyClass.color }
            PropertyChanges { 
                target: label
                color: _.anomalyClass.textColor
                text: `${_.anomalyClass.name || L.Tr.anomalyClass(L.Con.AnomalyClass.NoError)} ${label.posText}`
            }
        }
    ]

    QtObject {
        id: _

        readonly property var anomalyClass: root.customAnomalyClass ?? S.Store.view.anomalyClassByID(root.modelData.anomalyClassID)
    }

    Label {
        id: label

        readonly property string posText: `${L.LMath.roundToFixed(root.modelData.diagonal, 1)}mm`

        anchors {
            bottom: parent.top
            right: parent.right
        }
        color: "white"
        text: posText
        padding: 4
        font {
            pixelSize: Theme.fontSizeM
        }
        background: Rectangle {
            color: root.border.color
        }
    }

    VCB.Button {
        id: assignClass

        anchors {
            top: parent.bottom
            topMargin: Theme.spacingXXS
            horizontalCenter: parent.horizontalCenter
        }
        highlighted: true
        text: qsTr("Assign class")
        font {
            pixelSize: Theme.fontSizeM
            capitalization: Font.MixedCase
        }

        onClicked: root.classAssign()
    }
}
