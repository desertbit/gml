import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: root

    // Contains the width of the widest button.
    readonly property real widestButtonWidth: {
        let max = 0
        for (let i = 0; i < children.length; ++i) {
            const w = children[i].implicitWidth
            if (w > max) {
                max = w
            }
        }
        return max
    }
    onWidestButtonWidthChanged: {
        for (let i = 0; i < children.length; ++i) {
            children[i].Layout.preferredWidth = widestButtonWidth
        }
    }
}
