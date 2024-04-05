import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

import Theme

TextField {
    id: root

    property bool selectAllOnFocus: false

    font.pixelSize: Theme.fontSizeL
    selectByMouse: true
    topPadding: 0
    bottomPadding: 0

    onFocusChanged: {
        if (focus && (root.selectAllOnFocus || focusReason === Qt.TabFocusReason)) {
            selectAll()
        }
    }
}
