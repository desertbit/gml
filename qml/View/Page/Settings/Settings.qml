import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts


import Store
import Theme

import View.Component.Button as VCB
import View.Component.Container as VCC

import "Component"

VCC.Page {
    id: root

    title: qsTr("Settings")
    hasUnsavedChanges: netPane.hasUnsavedChanges || alertPane.hasUnsavedChanges || productDefaultSettingsPane.hasUnsavedChanges

    Flow {
        readonly property real paneWidth: 400
        readonly property real paneWidthLarge: paneWidth+Theme.spacingM

        anchors {
            top: parent.top
            left: parent.left
            right: actionColumn.left
            bottom: parent.bottom
            margins: Theme.spacingS
        }
        spacing: Theme.spacingS
        flow: Flow.TopToBottom

        CamerasPane {
            id: camerasPane

            height: parent.height
        }

        NetworkPane {
            id: netPane

            width: parent.paneWidth
        }

        AlertAndPausePane {
            id: alertPane

            width: parent.paneWidth
        }

        AboutPane {
            width: parent.paneWidth
        }

        ProductDefaultSettingsPane {
            id: productDefaultSettingsPane

            width: parent.paneWidthLarge
        }

        OptionsPane {
            width: parent.paneWidthLarge
        }

        AdvancedOptionsPane {
            width: parent.paneWidthLarge
            visible: Store.state.app.showAdvancedOptions
        }
    }

    VCC.WidestItemColumnLayout {
        id: actionColumn

        anchors {
            right: parent.right
            bottom: parent.bottom
            margins: Theme.spacingS
        }
        spacing: Theme.spacingS

        VCB.ActionButton {
            visible: Store.state.app.showAdvancedOptions
            icon.source: "qrc:/resources/icons/engineer_with_cogs.svg"
            text: qsTr("Setup")
            fontColor: Theme.colorForeground
            backgroundColor: Theme.colorBackground

            onClicked: A.ASetup.viewFromSettings()
        }

        Item { Layout.fillHeight: true } // Filler
    }
}
