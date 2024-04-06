import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action as A
import Lib as L
import Store
import Theme

import View.Component.Button as VCB
import View.Component.Form as VCF

// Displays the notification items inside a popup.
Popup {
    id: root

    y: parent.height
    contentWidth: 300

    ColumnLayout {
        id: content

        anchors.fill: parent

        Repeater {
            model: Store.state.notifications.items

            // This item is just a placeholder, as a delegate can only consist of one item.
            // We reparent all children of it at time of creation to the content layout.
            Item {
                id: delegate

                required property var modelData

                // Reparent all children to content layout.
                Component.onCompleted: {
                    while (children.length) {
                        children[0].parent = content
                    }
                }

                Loader {
                    Layout.fillWidth: true

                    // Load the delegate that fits the notification data type.
                    source: {
                        switch (delegate.modelData.type) {
                        case L.Con.Notification.UpdateAvailable:
                            return "UpdateDelegate.qml"
                        default:
                            return "ProgressDelegate.qml"
                        }
                    }
                }

                VCF.HorDivider {
                    height: 1

                    Layout.leftMargin: -root.padding/2
                    Layout.rightMargin: -root.padding/2
                }
            }
        }

        Text {
            text: qsTr("No notifications available")
            font {
                pixelSize: Theme.fontSizeM
                italic: true
            }
            visible: Store.state.notifications.items.empty()
        }
    }
}
