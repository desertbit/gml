import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

//
// This ComboBox sets its implicitWidth to its largest text item
// and adds the left and right padding on top. This ensures that its content
// will always be completely in sight by default.
//
// In addition, this ComboBox fixes a bug in the standard QtQuick.Controls.ComboBox,
// where the currentIndex gets reset everytime the model changes.
// See https://bugreports.qt.io/browse/QTBUG-111351
//
// The ComboBox also offers the syncTo property, which allows it to conveniently bind
// to a current state value and stay in sync with it, whilst still allowing normal user input.
//
ComboBox {
    id: root

    // WORKAROUND: Use this instead of setting currentIndex directly.
    // See https://bugreports.qt.io/browse/QTBUG-111351
    // Args:
    //  - idx(int) : The new current index
    function setCurrentIndex(idx) {
        _.currentIndex = idx
        currentIndex = idx
    }

    // Convenience function to quickly set the current value.
    // Args:
    //  - v(any) : The new current value
    function setCurrentValue(v) {
        _.currentIndex = indexOfValue(v)
        currentIndex = _.currentIndex
    }

    // Keep in sync with the given property, if set.
    // This causes the ComboBox to always follow the value of this state.
    // The property must adhere to the value role of the ComboBox.
    // Useful to allow the ComboBox to be user selected, while still updating itself
    // if an external state or something similar has been updated.
    property var syncTo: undefined
    onSyncToChanged: {
        if (syncTo === undefined) {
            return
        }
        setCurrentValue(syncTo)
    }

    // Custom width so the textbox is as wide as its widest item to display.
    implicitWidth: _.modelWidth + rightPadding + implicitIndicatorWidth

    // Sync our index.
    onActivated: _.currentIndex = currentIndex

    // Resize the ComboBox to its largest item.
    // As of the used QT version, this is only possible with a workaround.
    // When upgrading to QT6 or above, have a look at:
    // https://stackoverflow.com/a/71388046/5341805
    onModelChanged: {
        textMetrics.font = root.font
        for (let i = 0; i < model.length; i++) {
            textMetrics.text = textRole ? model[i][textRole] : model[i]
            _.modelWidth = Math.max(textMetrics.width, _.modelWidth)
        }

        // Restore the current index.
        // See https://bugreports.qt.io/browse/QTBUG-111351
        currentIndex = _.currentIndex
    }

    // Initialize with synced state.
    Component.onCompleted: {
        _.currentIndex = currentIndex

        if (syncTo !== undefined) {
            root.syncToChanged()
        }
    }

    QtObject {
        id: _

        // This property stores the required width to show 
        // all elements of the model adequately.
        property int modelWidth

        // WORKAROUND: Duplicates the currentIndex property, so we can
        // restore it after the model has changed.
        // This is for example triggered by a switch of the language.
        // See https://bugreports.qt.io/browse/QTBUG-111351
        property int currentIndex: 0
    }

    TextMetrics {
        id: textMetrics
    }
}
