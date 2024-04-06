import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts


import Store
import Theme

import View.Component.Button as VCB
import View.Component.Container as VCC

VCC.IconPane {
    id: root

    titleText: qsTr("Options")
    titleIconName: "settings"
    titleIconColor: Material.color(Material.Grey)
    contentSpacing: Theme.spacingS

    QtObject {
        id: _

        function update() {
            A.AApp.setOptions(debugMode.checked)
        }
    }

    ColumnLayout {
        Layout.fillWidth: true

        RowLayout {
            Label {
                font.pixelSize: Theme.fontSizeL
                text: qsTr("Debug mode")
            }

            Item { Layout.fillWidth: true }

            Switch {
                id: debugMode

                text: checked ? qsTr("On") : qsTr("Off")
                font.pixelSize: Theme.fontSizeL
                checked: Store.state.app.opts.debugMode

                onToggled: _.update()
            }
        }
    }
}
