import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick.Controls as QC // Calendar

import Lib as L
import Store
import Theme

import View.Component.Dialog as VCD

// Shows a dialog with a Calendar widget and optionally a time selector.
VCD.TrDialog {
    id: root

    // Contains the currently selected timestamp. Defaults to the current date.
    property date ts: new Date()
    // The oldest possible date. Defaults to the QML min date.
    property date minDate: L.LDate.Min
    // The newest possible date. Defaults to the QML max date.
    property date maxDate: L.LDate.Max
    // When true, the picker offers a selection for the time of the day as well.
    property bool time: false

    standardButtons: Dialog.Cancel | Dialog.Reset | Dialog.Ok
    // Make the calendar slightly bigger than the default.
    width: contentWidth + 137

    onTsChanged: {
        // If an invalid date is set, default to the current date.
        if (!ts.valid()) {
            ts = new Date()
            return
        }

        // Update the input fields.
        datePicker.selectedDate = ts
        hours.value = ts.getHours()
        minutes.value = ts.getMinutes()
        seconds.value = ts.getSeconds()
    }

    // Close the dialog on reset as well.
    Component.onCompleted: reset.connect(close)

    QtObject {
        id: _

        // True, when the user has selected the oldest possible date.
        readonly property bool minDateSelected: equalDates(datePicker.selectedDate, datePicker.minimumDate)
        // True, when the user has selected the newest possible date.
        readonly property bool maxDateSelected: equalDates(datePicker.selectedDate, datePicker.maximumDate)
        // The format of the date strings to use.
        readonly property string format: root.time ? qsTr("MM/dd/yy h:mm:ss AP") : qsTr("MM/dd/yy")

        // Returns true, if the year, month and day are equal for the given dates.
        function equalDates(d1, d2) {
            return d1.getFullYear() === d2.getFullYear() && d1.getMonth() === d2.getMonth() && d1.getDate() === d2.getDate()
        }
    }

    ColumnLayout {
        anchors.fill: parent

        QC.Calendar {
            id: datePicker

            locale: Qt.locale(Store.state.locale)
            weekNumbersVisible: true
            minimumDate: root.minDate.valid() ? root.minDate : L.LDate.Min
            maximumDate: root.maxDate.valid() ? root.maxDate : L.LDate.Max

            Layout.fillWidth: true
            Layout.fillHeight: true

            onClicked: date => root.ts = new Date(date.getFullYear(), date.getMonth(), date.getDate(), hours.value, minutes.value, seconds.value)
        }

        GridLayout {
            id: timeRow

            columns: 2
            visible: root.time

            Layout.topMargin: Theme.spacingXS

            // A slider that shows a label above the handle with the current value
            // of the slider.
            component LabeledSlider: Slider {
                from: 0
                to: 23
                stepSize: 1
                live: true
                snapMode: Slider.SnapAlways

                Layout.fillWidth: true

                Label {
                    id: label

                    // Positions the label like the handle.
                    anchors {
                        horizontalCenter: parent.handle.horizontalCenter
                        bottom: parent.handle.top
                        bottomMargin: Theme.spacingXXS
                    }
                    background: Rectangle {
                        radius: 5
                        color: Theme.colorBackgroundTier2
                    }
                    text: parent.value
                    leftPadding: Theme.spacingXXS
                    rightPadding: Theme.spacingXXS
                }
            }

            // Row1
            Label {
                text: qsTr("Hours:")
            }

            LabeledSlider {
                id: hours

                from: _.minDateSelected ? root.minDate.getHours() : 0
                to: _.maxDateSelected ? root.maxDate.getHours() : 23

                onMoved: root.ts = new Date(root.ts.getFullYear(), root.ts.getMonth(), root.ts.getDate(), value, minutes.value, seconds.value)
            }

            // Row2
            Label {
                text: qsTr("Minutes:")
            }
            LabeledSlider {
                id: minutes

                from: _.minDateSelected && hours.value === root.minDate.getHours() ? root.minDate.getMinutes() : 0
                to: _.maxDateSelected && hours.value === root.maxDate.getHours() ? root.maxDate.getMinutes() : 59

                onMoved: root.ts = new Date(root.ts.getFullYear(), root.ts.getMonth(), root.ts.getDate(), hours.value, value, seconds.value)
            }

            // Row3
            Label {
                text: qsTr("Seconds:")
            }
            LabeledSlider {
                id: seconds

                from: _.minDateSelected && hours.value === root.minDate.getHours() && minutes.value === root.minDate.getMinutes()
                      ? root.minDate.getSeconds() : 0
                to: _.maxDateSelected && hours.value === root.maxDate.getHours() && minutes.value === root.maxDate.getMinutes()
                    ? root.maxDate.getSeconds() : 59

                onMoved: root.ts = new Date(root.ts.getFullYear(), root.ts.getMonth(), root.ts.getDate(), hours.value, minutes.value, value)
            }
        }

        Label {
            font.pixelSize: Theme.fontSizeM
            text: qsTr("Selected: %1").arg(root.ts.toLocaleString(Qt.locale(Store.state.locale), _.format))

            Layout.topMargin: Theme.spacingS
        }
    }
}
