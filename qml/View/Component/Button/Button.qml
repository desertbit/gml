import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

import Theme

Button {
    id: root

    font {
        pixelSize: Theme.fontSizeM
        capitalization: Font.MixedCase
    }
    horizontalPadding: Theme.spacingS
    verticalPadding: 0

    states: [
        State {
            name: "medium"
            PropertyChanges { target: root; horizontalPadding: Theme.spacingM; verticalPadding: Theme.spacingS }
        },
        State {
            name: "large"
            extend: "medium"
            PropertyChanges { target: root; horizontalPadding: Theme.spacingL; font.pixelSize: Theme.fontSizeL }
        }
    ]
}
