import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import Action as A
import Lib as L
import Store
import Theme

import View.Component.Handler as VCH

Rectangle {
    id: root

    border {
        width: 2
        color: "black"
    }
    radius: width / 2
    color: {
        if (!L.State.isRun(Store.state.nline.state)) {
            return "lightgrey"
        } else if (Store.state.nline.state === L.State.RunPaused) {
            return "yellow"
        }
        return Store.state.runActive.stats.alarm === L.Con.AlarmCode.Ok ? "green" : "red"
    }

    VCH.Tap { onTapped: popup.open() }

    HoverHandler { id: hover }

    Popup {
        id: popup

        x: -width + parent.width
        y: parent.height
        visible: hover.hovered

        ColumnLayout {
            anchors.fill: parent
            spacing: 8

            Repeater {
                model: [
                    { color: "lightgrey", text: qsTr("No batch active") },
                    { color: "green", text: qsTr("Batch active") },
                    { color: "yellow", text: qsTr("Batch paused") },
                    { color: "red", text: qsTr("Error detected within the last 5 seconds") }
                ]

                RowLayout {
                    spacing: Theme.spacingXS

                    Rectangle {
                        border {
                            width: 1
                            color: "black"
                        }
                        color: modelData.color
                        radius: width/2
                        height: popupText.height
                        width: height

                        Layout.alignment: Qt.AlignTop
                    }

                    Text {
                        id: popupText

                        text: modelData.text
                        wrapMode: Text.WordWrap

                        Layout.maximumWidth: 220
                    }
                }
            }
        }
    }
}
