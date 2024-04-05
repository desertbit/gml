import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Lib as L
import Theme

import View.Component.Dialog as VCD

VCD.TrDialog {
    id: root

    // The maximum number of classes the user may select simultaneously.
    property alias max: selection.max
    // The description text shown in the dialog.
    property alias description: descriptionLabel.text

    // Emitted when the user clicks the save button.
    signal saved(var classIDs)

    // Show opens the dialog and calls the given callback once the user hits save.
    function show(selectedClassIDs) {
        selection.selectClassIDs(...selectedClassIDs)
        open()
    }

    standardButtons: Dialog.Save | Dialog.Cancel

    onAccepted: saved(selection.selectedClassIDs())

    ColumnLayout {
        anchors.fill: parent
        spacing: Theme.spacingS

        Text {
            id: descriptionLabel

            font.pixelSize: Theme.fontSizeL
        }

        Selection {
            id: selection

            width: descriptionLabel.implicitWidth
            height: 400
        }
    }
}
