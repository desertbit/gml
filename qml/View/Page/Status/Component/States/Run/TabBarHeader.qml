import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Store
import Theme

RowLayout {
    id: root

    property alias currentIndex: bar.currentIndex

    TabBar {
        id: bar

        Layout.fillWidth: true

        TabButton {
            text: qsTr("Live Events")
            width: implicitWidth + Theme.spacingM
            font {
                pixelSize: Theme.fontSizeL
                capitalization: Font.MixedCase
            }
        }

        TabButton {
            text: qsTr("Error Graph")
            width: implicitWidth + Theme.spacingM
            font {
                pixelSize: Theme.fontSizeL
                capitalization: Font.MixedCase
            }
        }

        TabButton {
            text: qsTr("Error Distribution")
            width: implicitWidth + Theme.spacingM
            font {
                pixelSize: Theme.fontSizeL
                capitalization: Font.MixedCase
            }
        }

        TabButton {
            text: qsTr("Measurement")
            width: implicitWidth + Theme.spacingM
            font {
                pixelSize: Theme.fontSizeL
                capitalization: Font.MixedCase
            }
            enabled: Store.state.runActive.enableMeasurement
        }
    }

    Row {
        spacing: Theme.spacingXS

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("Status")
            font {
                weight: Font.DemiBold
                pixelSize: Theme.fontSizeM
            }
        }

        AlarmLight {
            height: bar.height
            width: height
        }
    }
}
