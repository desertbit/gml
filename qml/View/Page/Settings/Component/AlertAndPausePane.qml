import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action as A
import Lib as L
import Store
import Theme

import View.Component.Button as VCB
import View.Component.Container as VCC
import View.Component.Event as VCE
import View.Component.Form as VCF

VCC.IconPane {
    id: root

    readonly property bool hasUnsavedChanges: enabled.checked !== Store.state.settings.alertAndPauseEnabled ||
                                              (codeSelect.currentCodes.length !== Store.state.settings.alertAndPauseEventCodes.length ||
                                                codeSelect.currentCodes.some((c, i) => Store.state.settings.alertAndPauseEventCodes[i] !== c))

    //: A mode where nLine pauses the run on each event and alerts the user via the kunbus IO API.
    titleText: qsTr("Alert & Pause")
    titleIconName: "alert-triangle"
    titleIconColor: Material.color(Material.Orange)
    spacing: Theme.spacingS

    titleRightContent: VCB.Button {
        text: qsTr("Apply")
        highlighted: true
        enabled: root.hasUnsavedChanges && codeSelect.currentCodes.length > 0

        onClicked: A.ASettings.setAlertAndPause(enabled.checked, codeSelect.currentCodes)
    }

    ColumnLayout {
        spacing: Theme.spacingM

        Text {
            text: qsTr(
                "In this mode nLine will pause the current batch whenever one of the selected events occurs.\n"+
                "The batch must then be resumed to continue the analysis."
            )
            font.pixelSize: Theme.fontSizeM
            wrapMode: Text.WordWrap

            Layout.fillWidth: true
        }

        Text {
            text: qsTr("Please note that this setting does not apply to the currently active batch.")
            font {
                italic: true
                pixelSize: Theme.fontSizeM
            }
            wrapMode: Text.WordWrap

            Layout.fillWidth: true
        }

        RowLayout {
            spacing: Theme.spacingM

            VCF.LabeledColumnLayout {
                labelText: qsTr("Enabled")

                Layout.fillWidth: true

                Switch {
                    id: enabled

                    checked: Store.state.settings.alertAndPauseEnabled
                    text: checked ? qsTr("On") : qsTr("Off")
                    font.pixelSize: Theme.fontSizeL
                    topPadding: 0
                    bottomPadding: 0

                    Layout.alignment: Qt.AlignRight
                }
            }

            VCF.LabeledColumnLayout {
                labelText: qsTr("Event types")

                Layout.fillWidth: true

                VCE.CodeSelect {
                    id: codeSelect

                    // Keep in sync with state.
                    readonly property var stateCodes: Store.state.settings.alertAndPauseEventCodes
                    onStateCodesChanged: selectCodes(stateCodes)
                }
            }
        }
    }
}
