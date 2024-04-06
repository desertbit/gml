import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Action as A
import Lib as L
import Store
import Theme

import View.Component.Button as VCB
import View.Component.Form as VCF

// Provides a textfield that shows a formatted date by default.
// The time (hours, minutes, seconds) can be optionally enabled as well.
// The ts property stores the current date.
// The formatting of the timestamp can be controlled via the locale and format properties.
// To react to a click on the calendor icon, use the `onActionClicked:` callback, which
// is typically used to show the ND.DateTimePicker.
Item {
    id: root

    property date ts: L.LDate.Invalid
    property alias minDate: picker.minDate
    property alias maxDate: picker.maxDate
    property alias time: picker.time
    property alias textField: field
    property bool defaultToMinDateWhenInvalid: false
    property bool defaultToMaxDateWhenInvalid: false

    // Emitted when the user selected a date.
    signal selected(date ts)

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    QtObject {
        id: _

        readonly property string dateFmt: root.time ? qsTr("MM/dd/yy h:mm:ss AP") : qsTr("MM/dd/yy")
    }

    PickerDialog {
        id: picker

        y: parent.implicitHeight + Theme.spacingXXXS
        margins: Theme.spacingXXS

        onAboutToShow: {
            ts = root.ts

            if (!root.ts.valid()) {
                if (minDate.valid() && (ts.before(minDate) || root.defaultToMinDateWhenInvalid)) {
                    ts = minDate
                } else if (maxDate.valid() && (ts.after(maxDate) || root.defaultToMaxDateWhenInvalid)) {
                    ts = maxDate
                }
            }
        }
        onAccepted: {
            root.ts = ts
            root.selected(root.ts)
        }
        onReset: {
            root.ts = L.LDate.Invalid
            root.selected(root.ts)
        }
    }

    RowLayout {
        id: row

        spacing: Theme.spacingXS

        VCF.TextField {
            id: field

            text: root.ts.valid() ? root.ts.toLocaleString(Qt.locale(Store.state.locale), _.dateFmt) : ""
            readOnly: true

            Layout.minimumWidth: 180

            onPressed: picker.open()
        }

        VCB.RoundIconButton {
            fontIcon {
                name: "calendar"
                size: Theme.iconSizeS
            }
            flat: true

            onClicked: picker.open()
        }
    }
}
