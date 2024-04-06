import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

import Theme

ColumnLayout {
    spacing: Theme.spacingL

    Row {
        spacing: Theme.spacingXS

        Layout.alignment: Qt.AlignHCenter

        Image {
            mipmap: true
            source: "qrc:/resources/images/logo-nline"
            fillMode: Image.PreserveAspectFit
            width: 300
            height: width / 654 * 143
        }

        Column {
            anchors.bottom: parent.bottom
            spacing: Theme.spacingXXS

            Text {
                font {
                    pixelSize: Theme.fontSizeS
                    italic: true
                }
                text: qsTr("Powered by")
            }

            Image {
                mipmap: true
                source: "qrc:/resources/images/logo-wahtari"
                fillMode: Image.PreserveAspectFit
                width: 150
                height: width / 895 * 115
            }
        }
    }

    Rectangle {
        height: 2
        radius: 2

        Layout.fillWidth: true

        LinearGradient {
            anchors.fill: parent
            cached: true
            start: Qt.point(0, 0)
            end: Qt.point(parent.width, 0)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "white" }
                GradientStop { position: 0.25; color: "black" }
                GradientStop { position: 0.7; color: Theme.colorAccent }
                GradientStop { position: 1.0; color: "white" }
            }
        }
    }
}
