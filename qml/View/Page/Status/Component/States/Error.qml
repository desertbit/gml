import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

import Action.State as AState

import Lib as L
import Theme
import Store

import View.Component.Button as VCB
import View.Component.Form as VCF
import View.Component.Text as VCT

import "../Table"

Base {
    id: root

    titleRightContent: [
        VCB.Button {
            text: qsTr("Confirm && Reset")
            highlighted: true
            state: "medium"

            onClicked: AState.resetError()
        }
    ]

    QtObject {
        id: _

        // Shorter alias.
        readonly property var err: Store.state.nline.stateErr
    }

    RowLayout {
        spacing: Theme.spacingXS

        Table {
            Table.Label {
                //: The error code when the nLine device is in the error state.
                text: qsTr("Code") + ":"
            }
            Table.Text { text: `${L.State.errTitle(_.err.code)} (${L.State.fmtErrCode(_.err.code)})` }

            Table.HorDivider {}

            Table.Label {
                //: The last state the nLine device was in before the current one.
                text: qsTr("Last state") + ":"
            }
            Table.Text { text: L.State.name(_.err.state) }
        }

        Table.VerDivider {}

        Table {
            Table.Label { text: L.State.entityName(_.err.state) + ":" }
            Table.Text { text: _.err.name || "---" }

            Table.HorDivider {}

            Table.Label { text: qsTr("Description") + ":"; Layout.alignment: Qt.AlignTop }
            Table.Text { 
                text: L.State.errDescription(_.err.code, _.err.msg)
                wrapMode: Text.WordWrap

                Layout.fillWidth: true
            }
        }
    }

    Item { Layout.fillHeight: true } // Filler
}
