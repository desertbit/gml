import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action as A
import Lib as L
import Theme

import View.Component.Dialog as VCD

import View.Page.AnomalyClass as VPA
import View.Page.Camera as VPC
import View.Page.ClassificationImage as VPClass
import View.Page.Dashboard as VPD
import View.Page.Event as VPE
import View.Page.Login as VPL
import View.Page.Help as VPHelp
import View.Page.PDFPreview as VPPdf
import View.Page.Product as VPP
import View.Page.Run as VPR
import View.Page.Settings as VPSett
import View.Page.Setup as VPS
import View.Page.Status as VPStat

import "../Base"

import "router.js" as Logic

Base {
    id: root

    function init(window, stack) {
        root._stack = stack
        root._unsavedChanges.parent = window.Overlay.overlay
    }

    onDispatched: function(type, data) {
        switch (type) {
        case "navigationPushPage":
            _stack.push(root[`_${data.page}Cmpt`])
            break

        case "navigationPopPage":
            Logic.checkForUnsavedChanges(root, () => {
                // Pop as many pages as requested.
                for (let i = 0; i < data.num; ++i) {
                    _stack.pop()
                }

                // Propagate to next middleware / store.
                next(type, data)
            })
            return

        case "navigationReplacePage":
            Logic.checkForUnsavedChanges(root, () => {
                // Replace the page.
                _stack.replace(_stack.get(_stack.depth-1 - (data.num-1)), root[`_${data.page}Cmpt`])

                // Propagate to next middleware / store.
                next(type, data)
            })
            return

        case "navigationPopToRoot":
            Logic.checkForUnsavedChanges(root, () => {
                // Pop all pages.
                _stack.pop(null)

                // Propagate to next middleware / store.
                next(type, data)
            })
            return
        }

        // Propagate to next middleware / store.
        next(type, data)
    }

    property StackView _stack

    readonly property VCD.TrDialog _unsavedChanges: VCD.TrDialog {
        property var rejectCb: null
        property var discardCb: null

        title: qsTr("Unsaved changes")
        standardButtons: Dialog.Discard | Dialog.Cancel
        anchors.centerIn: parent
        modal: true

        onRejected: rejectCb()
        onDiscarded: {
            discardCb()
            close()
        }

        ColumnLayout {
            anchors.fill: parent

            Text {
                font.pixelSize: Theme.fontSizeL
                text: qsTr("You have made changes that have not been saved yet.\nDo you want to discard them?")
            }
        }
    }

    readonly property Component _anomalyClassOverviewCmpt:               Component { VPA.Overview                      {} }
    readonly property Component _cameraDetailCmpt:                       Component { VPC.Detail                        {} }
    readonly property Component _cameraFocusCmpt:                        Component { VPC.Focus                         {} }
    readonly property Component _classificationImageCreateCmpt:          Component { VPClass.Create                    {} }
    readonly property Component _classificationImageDetailCmpt:          Component { VPClass.Detail                    {} }
    readonly property Component _classificationImageOverviewCmpt:        Component { VPClass.Overview                  {} }
    readonly property Component _dashboardCmpt:                          Component { VPD.Dashboard                     {} }
    readonly property Component _eventDetailCmpt:                        Component { VPE.Detail                        {} }
    readonly property Component _eventOverviewCmpt:                      Component { VPE.Overview                      {} }
    readonly property Component _helpCmpt:                               Component { VPHelp.Help                       {} }
    readonly property Component _loginConnectCmpt:                       Component { VPL.Connect                       {} }
    readonly property Component _loginDiscoveryCmpt:                     Component { VPL.Discovery                     {} }
    readonly property Component _pdfPreviewCmpt:                         Component { VPPdf.PDFPreview                  {} }
    readonly property Component _productCreateCmpt:                      Component { VPP.Create                        {} }
    readonly property Component _productDetailCmpt:                      Component { VPP.Detail                        {} }
    readonly property Component _productEditCmpt:                        Component { VPP.Edit                          {} }
    readonly property Component _productOverviewCmpt:                    Component { VPP.Overview                      {} }
    readonly property Component _productRetrainCmpt:                     Component { VPP.Retrain                       {} }
    readonly property Component _productTrainImagesCmpt:                 Component { VPP.TrainImages                   {} }
    readonly property Component _runCreateCmpt:                          Component { VPR.Create                        {} }
    readonly property Component _runDetailCmpt:                          Component { VPR.Detail                        {} }
    readonly property Component _runExportCmpt:                          Component { VPR.Export                        {} }
    readonly property Component _runOverviewCmpt:                        Component { VPR.Overview                      {} }
    readonly property Component _runRecentDetailCmpt:                    Component { VPR.RecentDetail                  {} }
    readonly property Component _runRecentOverviewCmpt:                  Component { VPR.RecentOverview                {} }
    readonly property Component _settingsCmpt:                           Component { VPSett.Settings                   {} }
    readonly property Component _setupCmpt:                              Component { VPS.Setup                         {} }
    readonly property Component _setupCameraMeasCalibCmpt:        Component { VPS.CameraMeasCalib        {} }
    readonly property Component _setupCameraMeasCalibGalleryCmpt: Component { VPS.CameraMeasCalibGallery {} }
    readonly property Component _statusCmpt:                             Component { VPStat.Status                     {} }
}
