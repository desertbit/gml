import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts


import Store
import Theme

import View.Component.Button as VCB
import View.Component.Container as VCC
import View.Component.Device as VCDev

BasePane {
    id: root

    signal saveToStorage(string os)

    title: qsTr("nVision")
    description: qsTr("The UI application of nLine available as native desktop application for both Windows and Linux.")
    icon: "monitor"
    withView: false

    onDownloadClicked: {
        if (Store.state.app.opts.withStorageDevices) {
            root.saveToStorage(_.selectedOS)
        } else {
            A.AHelpNVision.download(_.selectedOS)
        }
    }

    QtObject {
        id: _

        readonly property string selectedOS: osWindows.checked ? "windows" : "linux"
    }

    ColumnLayout {
        Text {
            text: qsTr("Select your target operating system:")
            wrapMode: Text.WordWrap
            horizontalAlignment: Qt.AlignHCenter

            Layout.fillWidth: true
        }

        Row {
            Layout.alignment: Qt.AlignHCenter

            RadioButton {
                id: osWindows

                text: qsTr("Windows")
                checked: true
            }

            RadioButton { text: qsTr("Linux") }
        }
    }
}
