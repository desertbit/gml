import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts


import Store
import Theme

import View.Component.Button as VCB
import View.Component.ComboBox as VCCombo

// TODO: Can this be removed? Currently unused.
Column {
    id: root

    property alias text: filePath
    property alias button: action

    spacing: Theme.spacingXS

    VCB.Button {
        id: action

        state: "medium"

        onClicked: A.AApp.selectFileLocation()
    }

    Text {
        id: filePath

        font.pixelSize: Theme.fontSizeL
        wrapMode: Text.WordWrap
        elide: Text.ElideMiddle
    }
}
