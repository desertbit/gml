import QtQuick

import Theme

Text {
    id: root

    font {
        pixelSize: Theme.fontSizeM
        weight: Font.DemiBold
    }
    color: Theme.error
    visible: !!text
    wrapMode: Text.WordWrap
}
