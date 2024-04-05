import QtQuick

import Theme

Text {
    id: root

    // The text of the label.
    property string label: ""

    // If true, a red star indicator is shown on the right side of the label.
    property bool required: false

    text: root.required ? `${label} <font size="4" color="${Theme.error}">*</font>` : label
    // RichText is required for custom text coloring of the required indicator.
    textFormat: TextEdit.RichText
    font {
        pixelSize: Theme.fontSizeM
        weight: Font.DemiBold
    }
}
