import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick.Window


import Store
import Theme

import View.Component.Button as VCB
import View.Component.Container as VCC

VCC.IconPane {
    id: root

    titleText: qsTr("Update")
    titleIconName: "download"
    titleIconColor: Material.color(Material.Indigo)
    spacing: Theme.spacingS

    QtObject {
        id: priv

        function downloadAndQuit() {
            app.showLoadingOverlay(0, qsTr("Downloading nVision update..."))
            S.State.connect.installNVision(() => Qt.quit())
        }
    }

    ColumnLayout {
        Layout.fillWidth: true

        Label {
            font.pixelSize: Theme.fontSizeL
            text: qsTr(
                "A new version of nVision is available for installation.\n" +
                "After the successful download of the update, nVision will restart automatically."
            )
            wrapMode: Label.WordWrap

            Layout.fillWidth: true
            Layout.bottomMargin: Theme.spacingL
        }

        VCB.Button {
            text: qsTr("Install")
            state: "medium"
            highlighted: true

            onClicked: priv.app.confirmAction(
                qsTr("Install update"),
                qsTr("Do you wish to install the update now?\n" +
                    "This will close nVision once the download has finished."
                ),
                priv.downloadAndQuit
            )

            Layout.alignment: Qt.AlignHCenter
        }
    }
}
