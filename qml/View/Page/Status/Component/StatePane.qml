import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Lib as L
import Store
import Theme

import View.Component.Button as VCB
import View.Component.Container as VCC
import View.Component.Text as VCT

VCC.IconPane {
    id: root

    titleIconName: "activity"
    titleIconColor: Theme.colorPrimary
    titleText: qsTr("nLine")
    title.font.pixelSize: Theme.fontSizeL
    titleLeftContent: [
        VCT.PaneLabel {
            text: qsTr("State: %1").arg(L.State.name(Store.state.nline.state))
            font {
                pixelSize: Theme.fontSizeL
                weight: Font.DemiBold
            }
            color: _.stateForegroundColor(Store.state.nline.state)
            topPadding: Theme.spacingXS
            bottomPadding: Theme.spacingXS

            Layout.leftMargin: Theme.spacingM
            Material.background: _.stateBackgroundColor(Store.state.nline.state)
        }
    ]
    titleRightContent: loader.status === Loader.Ready ? loader.item.titleRightContent : []
    titleRightContentSpacing: Theme.spacingXS

    QtObject {
        id: _

        function stateForegroundColor(state) {
            switch (state) {
            default:
                return "white"
            }
        }

        function stateBackgroundColor(state) {
            switch (state) {
            case L.State.Setup:        return Theme.colorSetup
            case L.State.Ready:        return Theme.success
            case L.State.Run:          return Theme.colorRun
            case L.State.RunPaused:    return Theme.colorRunTier2
            case L.State.ClassifyRun:  return Theme.colorClassifyRun
            case L.State.Error:        return Theme.error
            default:
                if (L.State.isTrain(state)) {
                    return Theme.colorProduct
                }
                return Material.color(Material.Grey)
            }
        }
    }

    Loader {
        id: loader

        Layout.fillWidth: true
        Layout.fillHeight: true

        source: {
            const state = Store.state.nline.state
            switch (state) {
            case L.State.Setup:
                return "States/Setup.qml"
            case L.State.Ready:
                return "States/Ready.qml"
            case L.State.Run:
            case L.State.RunPaused:
                return "States/Run.qml"
            case L.State.ClassifyRun:
                return "States/ClassifyRun.qml"
            case L.State.Error:
                return "States/Error.qml"
            default:
                if (L.State.isTrain(state)) {
                    return "States/Train.qml"
                }
                return ""
            }
        }
    }
}
