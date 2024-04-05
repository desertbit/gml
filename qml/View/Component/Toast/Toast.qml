import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import QtGraphicalEffects

import Theme
import View.Component.Handler as VCH
import View.Component.Icon as VCI

Pane {
    id: root

    enum Type {
        Warning,
        Error,
        Info,
        Success
    }

    // The type of the message to be displayed.
    property int type: Toast.Type.Info
    // The message shown to the user.
    property alias message: msg.text
    // A timeout in milliseconds. If > 0, the toast closes itself automatically after the timer expires.
    property alias timeout: timer.interval

    // open transitions the toast to the open state and shows the toast.
    // If a timeout is configured, a timer is started to transition back to the closed state automatically.
    function open() {
        root.state = "open"
        if (timeout > 0) {
            timer.restart()
        }
    }

    // close transitions the toast to the closed state and hides the toast.
    function close() { root.state = "closed" }

    width: 500
    opacity: 0
    visible: false

    Material.elevation: 2

    state: "closed"
    states: [
        State {
            name: "open"
            PropertyChanges {
                target: root
                opacity: 1
                visible: true
            }
        }
    ]

    transitions: [
        Transition {
            from: "closed"
            to: "open"
            NumberAnimation { properties: "opacity"; duration: 200 }
        }
    ]

    background: Rectangle {
        border {
            width: 1
            color: _.getBorderColor(root.type)
        }
    }

    QtObject {
        id: _

        // Returns the foreground color for the message.
        // Args:
        //  - type(int) : Enum type.
        // Ret:
        //  - foregroundColor(color)
        function getForegroundColor(type) {
            return Theme.foreground
        }

        // Returns the border color for the toast.
        // Args:
        //  - type(int) : Enum type.
        // Ret:
        //  - borderColor(color)
        function getBorderColor(type) {
            switch (type) {
            case Toast.Type.Warning:
                return Material.color(Material.Orange)
            case Toast.Type.Error:
                return Material.color(Material.Error)
            case Toast.Type.Info:
                return Material.color(Material.Blue)
            case Toast.Type.Success:
                return Material.color(Material.Green)
            default:
                return ""
            }
        }

        // Returns the title for the toast.
        // Args:
        //  - type(int) : Enum type.
        // Ret:
        //  - title(string)
        function getTitle(type) {
            switch (type) {
            case Toast.Type.Warning:
                return qsTr("Warning")
            case Toast.Type.Error:
                return qsTr("Error")
            case Toast.Type.Info:
                return qsTr("Info")
            case Toast.Type.Success:
                return qsTr("Success")
            default:
                return ""
            }
        }

        // Returns the icon name for the toast.
        // Args:
        //  - type(int) : Enum type.
        // Ret:
        //  - iconName(string)
        function getIconName(type) {
            switch (type) {
            case Toast.Type.Warning:
                return "alert-triangle"
            case Toast.Type.Error:
                return "x-circle"
            case Toast.Type.Info:
                return "info"
            case Toast.Type.Success:
                return "check"
            default:
                return ""
            }
        }
    }

    // A timer to automatically close the toast after a timeout.
    // By default, we close the toast after 5 seconds.
    Timer {
        id: timer

        interval: 5000
        repeat: false

        onTriggered: root.close()
    }

    ColumnLayout {
        spacing: Theme.spacingXS
        anchors.fill: parent

        RowLayout {
            spacing: Theme.spacingXS

            VCI.Icon {
                name: _.getIconName(root.type)
                size: 28
                color: _.getBorderColor(root.type)

                Layout.alignment: Qt.AlignTop
            }

            Text {
                text: _.getTitle(root.type)
                font.pixelSize: Theme.fontSizeXL
                font.weight: Font.DemiBold

                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop

            }

            // An icon to dismiss the toast.
            VCI.Icon {
                name: "x"
                size: Theme.fontSizeXL

                Layout.alignment: Qt.AlignRight

                HoverHandler {
                    cursorShape: Qt.PointingHandCursor
                    margin: tap.margin
                }

                VCH.Tap {
                    id: tap

                    margin: Theme.spacingM

                    onSingleTapped: root.close()
                }
            }
        }

        // Gradient divider.
        Rectangle {
            height: 2
            radius: 2

            Layout.fillWidth: true
            Layout.bottomMargin: parent.spacing

            LinearGradient {
                   anchors.fill: parent
                   cached: true
                   start: Qt.point(0, 0)
                   end: Qt.point(parent.width, 0)
                   gradient: Gradient {
                       GradientStop { position: 0.0; color: "white" }
                       GradientStop { position: 0.15; color: _.getBorderColor(root.type) }
                       GradientStop { position: 0.7; color: "black" }
                       GradientStop { position: 1.0; color: "white" }
                   }
               }
        }

        // The text message shown to the user.
        Text {
            id: msg

            text: message
            wrapMode: Text.WordWrap
            color: Theme.colorForeground
            font.pixelSize: Theme.fontSizeL

            Layout.fillWidth: true
        }
    }
}
