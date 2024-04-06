import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import Action as A
import Lib as L
import Store
import Theme

import View.Component.Container as VCC

import "Component"

VCC.Page {
    id: root

    title: qsTr("Dashboard")

    states: [
        State {
            name: "disabled"
            when: L.State.isTrain(Store.state.nline.state)
            PropertyChanges { target: content; visible: false }
            PropertyChanges { target: disabledLabel; visible: true }
        }
    ]

    QtObject {
        id: _

        readonly property real paneSpacing: Theme.spacingS
        readonly property real paneHalfWidth: (content.width / 2) - (content.spacing / 2)
        readonly property real paneThirdWidth: (content.width / 3) - ((content.spacing * 2) / 3)
        readonly property real paneQuarterWidth: (content.width / 4) - ((content.spacing * 3) / 4)
        readonly property real paneHeight: (content.height - content.spacing) / 2
    }

    ColumnLayout {
        id: content

        anchors {
            fill: parent
            margins: _.paneSpacing
        }
        spacing: _.paneSpacing

        RowLayout {
            spacing: _.paneSpacing

            Info {
                Layout.preferredWidth: _.paneQuarterWidth
                Layout.preferredHeight: _.paneHeight
            }

            GPUInfo {
                Layout.preferredWidth: _.paneQuarterWidth
                Layout.preferredHeight: _.paneHeight
            }

            BinPieStat {
                //: The computer memory, not the brain memory.
                titleText: qsTr("Memory")
                titleIconName: "save"
                available: Store.state.nline.stats.mem.available
                used: Store.state.nline.stats.mem.used
                usedPct: Store.state.nline.stats.mem.usedPct

                Layout.preferredWidth: _.paneQuarterWidth
                Layout.preferredHeight: _.paneHeight
            }

            Repeater {
                model: Store.state.nline.stats.disks

                BinPieStat {
                    //: The computer storage.
                    titleText: qsTr("Storage")
                    subtitle: modelData.path
                    titleIconName: "database"
                    available: modelData.free
                    used: modelData.used
                    usedPct: modelData.usedPct

                    Layout.preferredWidth: _.paneQuarterWidth
                    Layout.preferredHeight: _.paneHeight
                }
            }
        }

        RowLayout {
            spacing: _.paneSpacing

            Layout.fillHeight: true

            CPUUsage {
                Layout.preferredWidth: _.paneHalfWidth
                Layout.preferredHeight: _.paneHeight
            }

            TempStats {
                Layout.preferredWidth: _.paneHalfWidth
                Layout.preferredHeight: _.paneHeight
            }
        }
    }

    Text {
        id: disabledLabel

        anchors.centerIn: parent
        text: qsTr("System stats currently not available during training.")
        font {
            italic: true
            pixelSize: Theme.fontSizeXL
        }
        visible: false
    }
}
