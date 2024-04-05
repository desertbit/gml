import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQml.Models

import Lib as L
import Theme

// The TrDialog simply wraps the native dialog and takes care (rather gracefully I must say)
// of handling the missing translations for the standard buttons.
// This is necessary, because we were not able yet to incorporate the translation base files
// of Qt into our own.
// Normally, this should also just work out of the box, but it doesn't (probably due to GML).
// Maybe this fixes itself with the new Qt6 / GML? Check again, if it does in the future.
Dialog {
    id: root

    // Custom header since the default one does throw a property binding loop on the implicitWidth
    // whenever a title with more than one word is being used...
    header: Item {
        implicitWidth: titleText.implicitWidth + (2*root.padding)
        implicitHeight: titleText.implicitHeight + root.padding

        Text {
            id: titleText

            anchors {
                fill: parent
                margins: root.padding
            }
            text: root.title
            font {
                pixelSize: Theme.fontSizeM
                weight: Font.DemiBold
            }
        }
    }

    footer: DialogButtonBox {
        delegate: Button {
            flat: true

            Component.onCompleted: {
                // This is the original text, which equals the english version of the button.
                // So "OK" for the Dialog.Ok button, for example.
                // We use this as our key into the translation.
                const textCopy = text
                // Make a property binding, so the locale change trigges a text change.
                text = Qt.binding(() => L.Tr.dialogButtonText(textCopy))
                // We need to connect to this signal, as the C++ side of the DialogButtonBox
                // sets the text itself everytime the locale is changed.
                // We overwrite it here again.
                textChanged.connect(() => text = Qt.binding(() => L.Tr.dialogButtonText(textCopy)))
            }
        }
    }
}
