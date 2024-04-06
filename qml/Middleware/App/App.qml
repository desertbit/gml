import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs as QD
import Qt.labs.settings

import Action as A
import Lib as L
import Theme

import View.Component.Dialog as VCD
import View.Component.State as VCS
import View.Component.Toast as VCT

import "../Base"
import "Component"

// BUG(Qt): The "import Action as A" shadows our local imports, that's why we have the 'Local' prefix for now.

import "AnomalyClass/anomalyClass.js" as LocalAnomalyClass

import "App/app.js" as LocalApp
import "App/toast.js" as LocalAppToast

import "ClassificationImage/classificationImage.js" as LocalClassificationImage

import "Global/global.js" as LocalGlobal

import "Help/nvision.js" as LocalHelpNVision
import "Help/resource.js" as LocalHelpResource

import "Login/connect.js" as LocalLoginConnect

import "Product/product.js" as LocalProduct
import "Product/create.js" as LocalProductCreate
import "Product/retrain.js" as LocalProductRetrain
import "Product/trainImages.js" as LocalProductTrainImages

import "Run/run.js" as LocalRun
import "Run/active.js" as LocalRunActive
import "Run/export.js" as LocalRunExport

import "Settings/settings.js" as LocalSettings

import "Setup/setup.js" as LocalSetup
import "Setup/cameraMeasCalibGallery.js" as LocalSetupCameraMeasCalibGallery

import "State/state.js" as LocalState

// The App middleware handles certain actions that concern the locally running nVision application.
// This includes opening system dialogs, writing and loading local user settings, quitting, etc.
// To handle a certain action, simply add a function with the same name to one of the handler scripts.
//
// A handler function must have the following signature:
//
//    function <action-type>(app, type, data)
//
// where app is this Middleware object.
Base {
    id: root

    onDispatched: function(type, data) {
        // Find matching handler.
        for (const key in _handlers) {
            if (!type.startsWith(key)) {
                continue
            }

            const handler = _handlers[key]
            const funcName = type.substring(key.length).lowercase()
            if (!handler.hasOwnProperty(funcName)) {
                continue
            }

            // Call handler with the current internal state.
            handler[funcName](root, type, data)
            return
        }

        // No handler triggered, continue.
        next(type, data)
    }

    // Stores handlers for actions.
    readonly property var _handlers: ({
        "anomalyClass":                LocalAnomalyClass,
        "app":                         LocalApp,
        "appToast":                    LocalAppToast,
        "classificationImage":         LocalClassificationImage,
        "global":                      LocalGlobal,
        "helpNVision":                 LocalHelpNVision,
        "helpResource":                LocalHelpResource,
        "loginConnect":                LocalLoginConnect,
        "product":                     LocalProduct,
        "productCreate":               LocalProductCreate,
        "productRetrain":              LocalProductRetrain,
        "productTrainImages":          LocalProductTrainImages,
        "run":                         LocalRun,
        "runActive":                   LocalRunActive,
        "runExport":                   LocalRunExport,
        "settings":                    LocalSettings,
        "setup":                       LocalSetup,
        "setupCameraMeasCalibGallery": LocalSetupCameraMeasCalibGallery,
        "state":                       LocalState
    })

    // init initializes this middleware by setting the parent of the dialogs.
    // Args:
    //  - window(ApplicationWindow) : The main application window.
    function init(window) {
        // Assign overlay as parent.
        for (const v of [deleteOneDialog, deleteManyDialog, busyDialog, confirmDialog, updateRequiredDialog, stateErrPopup, toast]) {
            v.parent = window.Overlay.overlay
        }
    }

    readonly property VCD.DeleteOne deleteOneDialog: VCD.DeleteOne {
        onDeleted: (type, data) => root.next(type, data)
        onCanceled: root.consumed()
    }

    readonly property VCD.DeleteMany deleteManyDialog: VCD.DeleteMany {
        width: 600

        onDeleted: (type, data) => root.next(type, data)
        onCanceled: root.consumed()
    }

    // Unfortunately, this causes some error messages to be printed on startup:
    //  - file:///usr/lib/qt/qml/QtQuick/Dialogs/DefaultFileDialog.qml:413:17: QML ToolButton: Binding loop detected for property "implicitHeight"
    //  - file:///usr/lib/qt/qml/QtQuick/Dialogs/DefaultFileDialog.qml:309:21: QML Button: Binding loop detected for property "implicitHeight"
    //  - file:///usr/lib/qt/qml/QtQuick/Dialogs/DefaultFileDialog.qml:309:21: QML Button: Binding loop detected for property "implicitHeight"
    //  - file:///usr/lib/qt/qml/QtQuick/Controls/ToolBar.qml:146:9: QML QQuickItem*: Binding loop detected for property "layoutHeight"
    // Update to Qt6 hopefully fixes this.
    readonly property QD.FileDialog fileDialog: QD.FileDialog {
        // A callback function that receives as single argument the selected file urls.
        property var cb

        //: A location on a disk drive.
        title: qsTr("Please choose a location to save the file to.")
        options: FileDialog.ReadOnly

        onAccepted: cb(fileDialog.selectedFiles)
        onRejected: root.consumed()
    }

    readonly property QD.ColorDialog colorDialog: QD.ColorDialog {
        // A callback function that receives as single argument the selected color.
        property var cb

        // Saves the given callback in colorDialog and opens it.
        // Args:
        //  cb(func) : A callback function with signature color -> void.
        function show(cb) {
            colorDialog.cb = cb
            open()
        }

        title: qsTr("Please choose a color")

        onAccepted: cb(colorDialog.color)
        onRejected: root.consumed()
    }

    readonly property VCD.Busy busyDialog: VCD.Busy {
        property int callID: 0

        anchors.centerIn: parent
        standardButtons: callID > 0 ? Dialog.Cancel : 0

        // Abort the operation.
        onRejected: A.AInternal.emitCancel(callID)
        onClosed: callID = 0
    }

    readonly property ConfirmDialog confirmDialog: ConfirmDialog {
        anchors.centerIn: parent

        onConfirmed: (type, data) => root.next(type, data)
        onDenied: root.consumed()
    }

    readonly property ConfirmDialog updateRequiredDialog: ConfirmDialog {
        anchors.centerIn: parent
        standardButtons: Dialog.Yes | Dialog.No
    }

    readonly property VCS.ErrorPopup stateErrPopup: VCS.ErrorPopup {
        anchors.centerIn: parent

        onConfirmed: A.AState.resetError()
    }

    readonly property Settings settings: Settings {
        property string locale: "en_US"
        property var runActiveEventFilterCodes: L.Event.Codes
    }

    readonly property VCT.Toast toast: VCT.Toast {
        // Position inside the Overlay item at the top right.
        x: parent.width - width - Theme.spacingXS
        y: Theme.toolbarHeight + Theme.spacingXS
    }
}
