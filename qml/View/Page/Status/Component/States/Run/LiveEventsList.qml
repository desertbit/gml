import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts


import Store
import Theme

import View.Component.Event as VCE

ListView {
    id: root

    clip: true
    spacing: 2
    // FIXME: When the model is cleared, the items are pooled in the listview for reuse,
    // which causes the delegate's property bindings to still be evaluated.
    // Changing the locale causes then a lot of error messages to be printed to the console.
    // Not sure if this is intended or a bug.
    reuseItems: false
    model: Store.state.runActive.events.model

    ScrollBar.vertical: ScrollBar {
        snapMode: ScrollBar.SnapAlways
        minimumSize: 0.1
        width: 20
    }

    delegate: VCE.ListDelegate {
        width: root.width
        height: 100
        inset: Theme.spacingL

        onTapped: id => A.AEventDetail.viewFromStatus(id, Store.state.runActive.id, Store.state.runActive.productID)
    }

    Text {
        anchors.centerIn: parent
        text: qsTr("No live events available")
        color: Theme.colorForegroundTier2
        visible: root.model.length === 0
        font {
            italic: true
            pixelSize: Theme.fontSizeXL
        }
    }
}
