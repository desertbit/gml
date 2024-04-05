import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQml as TEST

import Lib as L
import Store
import Store.Model as SM
import Theme

import View.Component.Button as VCB
import View.Component.Container as VCC
import View.Component.Form as VCF
import View.Component.Run as VCR

// General Info
VCC.IconPane {
    id: root

    required property SM.RunDetail model

    titleText: qsTr("Info")
    titleIconName: "info"
    titleIconColor: Material.color(Material.Blue)
    contentSpacing: Theme.spacingM

    titleRightContent: Label {
        id: failedTag

        background: Rectangle { radius: 4; color: Theme.error }
        text: qsTr("Failed")
        font {
            weight: Font.DemiBold
            pixelSize: Theme.fontSizeM
            capitalization: Font.AllUppercase
        }
        color: "white"
        padding: Theme.spacingXXS
        visible: false
    }

    states: [
        State {
            name: "failed"
            when: root.model.hasFailed
            PropertyChanges { target: failedTag; visible: true }
            PropertyChanges { target: errRow; visible: true }
        },
        State {
            name: "active"
            when: !root.model.isFinished
            PropertyChanges { target: runtime; text: qsTr("Currently active"); font.weight: Font.DemiBold }
        }
    ]

    RowLayout {
        spacing: Theme.spacingL

        VCF.LabeledColumnLayout {
            labelText: qsTr("Name")

            Text {
                font.pixelSize: Theme.fontSizeL
                text: root.model.name

                Layout.fillWidth: true
            }
        }
    }

    RowLayout {
        spacing: Theme.spacingL

        VCF.LabeledColumnLayout {
            labelText: qsTr("Created on")

            Layout.alignment: Qt.AlignTop

            Text {
                font.pixelSize: Theme.fontSizeL
                text: root.model.created.formatDateTime(Store.state.locale)
            }
        }

        VCF.LabeledColumnLayout {
            labelText: qsTr("Finished on")

            Layout.alignment: Qt.AlignTop

            Text {
                font.pixelSize: Theme.fontSizeL
                text: root.model.isFinished ? root.model.finished.formatDateTime(Store.state.locale) : "---"
            }
        }

        VCF.LabeledColumnLayout {
            labelText: qsTr("Runtime")

            Layout.alignment: Qt.AlignTop

            Text {
                id: runtime

                font.pixelSize: Theme.fontSizeL
                text: L.LDate.formatDuration(root.model.duration)
            }
        }
    }

    RowLayout {
        spacing: Theme.spacingL

        VCF.LabeledColumnLayout {
            labelText: qsTr("Speed (m/min)")

            Row {
                spacing: Theme.spacingS

                Text {
                    font.pixelSize: Theme.fontSizeL
                    text: qsTr("Avg. %L1").arg(L.LMath.roundToFixed(root.model.avgSpeed/100, 2))
                }
                Text {
                    font.pixelSize: Theme.fontSizeL
                    text: qsTr("Min. %L1").arg(L.LMath.roundToFixed(root.model.minSpeed/100, 2))
                }
                Text {
                    font.pixelSize: Theme.fontSizeL
                    text: qsTr("Max. %L1").arg(L.LMath.roundToFixed(root.model.maxSpeed/100, 2))
                }
            }
        }

        VCF.LabeledColumnLayout {
            labelText: qsTr("Length (m)")

            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop

            Text {
                font.pixelSize: Theme.fontSizeL
                text: L.LMath.roundToFixed(root.model.length/100, 2)
            }
        }
    }

    RowLayout {
        id: errRow

        spacing: Theme.spacingL
        visible: false

        VCF.LabeledColumnLayout {
            labelText: qsTr("Error Code")
            label {
                font.weight: Font.DemiBold
                color: Theme.error
            }

            Layout.alignment: Qt.AlignTop

            Text {
                font.pixelSize: Theme.fontSizeM
                text: L.State.fmtErrCode(root.model.errCode)
            }
        }

        VCF.LabeledColumnLayout {
            labelText: qsTr("Error Message")
            label {
                font.weight: Font.DemiBold
                color: Theme.error
            }

            Text {
                font.pixelSize: Theme.fontSizeM
                text: L.State.errDescription(root.model.errCode, root.model.errMsg)
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
        }
    }

    RowLayout {
        spacing: Theme.spacingL

        VCF.LabeledColumnLayout {
            labelText: qsTr("Description")

            Text {
                font.pixelSize: Theme.fontSizeL
                text: "---"
                maximumLineCount: 3
                elide: Text.ElideRight
                wrapMode: Text.WordWrap

                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }

        VCF.LabeledColumnLayout {
            //: Number of pauses are in the parenthesis.
            labelText: qsTr("Pauses (%L1)").arg(root.model.pauses.length)

            Layout.alignment: Qt.AlignTop

            VCB.RoundIconButton {
                fontIcon {
                    name: "eye"
                    size: Theme.iconSizeS
                }
                flat: true

                onClicked: {
                    if (root.model.pauses.length > 0) {
                        pauses.open()
                    }
                }
            }

            VCR.PausesPopup {
                id: pauses

                x: parent.width + margins
                pauses: root.model.pauses
            }
        }
    }
}
