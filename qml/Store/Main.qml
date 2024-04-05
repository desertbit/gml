import QtQuick

import Dispatcher
import Lib as L

import Store.Model as SM

import "AnomalyClass/anomalyClass.js" as AnomalyClass

import "App/app.js" as App

import "Camera/camera.js" as Camera
import "Camera/detail.js" as CameraDetail
import "Camera/focus.js" as CameraFocus

import "ClassificationImage/classificationImage.js" as ClassificationImage
import "ClassificationImage/create.js" as ClassificationImageCreate
import "ClassificationImage/detail.js" as ClassificationImageDetail
import "ClassificationImage/overview.js" as ClassificationImageOverview

import "Dashboard/dashboard.js" as Dashboard

import "Dev/dev.js" as Dev

import "Event/detail.js" as EventDetail
import "Event/overview.js" as EventOverview

import "Global/global.js" as Global

import "Help/help.js" as Help
import "Help/nvision.js" as HelpNVision
import "Help/resource.js" as HelpResource

import "Login/login.js" as Login
import "Login/connect.js" as LoginConnect
import "Login/discovery.js" as LoginDiscovery

import "Navigation/navigation.js" as Navigation

import "Notification/notification.js" as Notification

import "PDFPreview/pdfPreview.js" as PDFPreview

import "Product/product.js" as Product
import "Product/create.js" as ProductCreate
import "Product/detail.js" as ProductDetail
import "Product/overview.js" as ProductOverview
import "Product/retrain.js" as ProductRetrain
import "Product/trainImages.js" as ProductTrainImages

import "Run/run.js" as Run
import "Run/active.js" as RunActive
import "Run/create.js" as RunCreate
import "Run/detail.js" as RunDetail
import "Run/export.js" as RunExport
import "Run/overview.js" as RunOverview
import "Run/recentDetail.js" as RunRecentDetail
import "Run/recentOverview.js" as RunRecentOverview

import "Settings/settings.js" as Settings

import "Setup/setup.js" as Setup
import "Setup/cameraMeasCalib.js" as SetupCameraMeasCalib
import "Setup/cameraMeasCalibGallery.js" as SetupCameraMeasCalibGallery

import "State/state.js" as SState

import "Status/status.js" as Status

import "initState.js" as IS

// The Main store which encapsulates the complete application state.
// Contrary to common Flux Architecture, we simply use a single store with a single dispatch.
// This is more similar to how Redux handles this.
//
// The public state is a QtObject, which triggers updates into the UI automatically via property bindings.
// There is also an internal state that the reducers use to modify the state.
// Once a reducer is done, the internal state is copied onto the public state.
//
// Please consult the README for further information about Flux/Redux Architecture.
QtObject {
    id: root

    property QtObject state: QtObject {
        // General data.

        property string locale: "en_US"
        property var locales: ["en_US", "de_DE"]

        property bool loggedIn: false

        // The current local application state.
        property SM.App app: SM.App {}
        // All available cameras. Contains Model.Camera objects.
        property var cameras: []
        // All available motors. Contains string ids.
        property var motorIDs: []
        // The current state of the nline device.
        property SM.NLine nline: SM.NLine {}
        // All available anomaly classes. Contains Model.AnomalyClass objects.
        property var anomalyClasses: []
        // All available products. Contains Model.Product objects.
        property var products: []
        // The current notifications.
        property SM.Notifications notifications: SM.Notifications {}
        // The internal developer data.
        property SM.Dev dev: SM.Dev {}

        // Page specific data.
        property SM.AnomalyClassOverview anomalyClassOverview: SM.AnomalyClassOverview {}
        property SM.CameraDetail cameraDetail: SM.CameraDetail {}
        property SM.CameraFocus cameraFocus: SM.CameraFocus {}
        property SM.ClassificationImageCreate classificationImageCreate: SM.ClassificationImageCreate {}
        property SM.ClassificationImageDetail classificationImageDetail: SM.ClassificationImageDetail {}
        property SM.ClassificationImageOverview classificationImageOverview: SM.ClassificationImageOverview {}
        property SM.EventDetail eventDetail: SM.EventDetail {}
        property SM.EventOverview eventOverview: SM.EventOverview {}
        property SM.LoginConnect loginConnect: SM.LoginConnect {}
        property SM.LoginDiscovery loginDiscovery: SM.LoginDiscovery {}
        property SM.PDFPreview pdfPreview: SM.PDFPreview {}
        property SM.ProductDefaultSettings productDefaultSettings: SM.ProductDefaultSettings {}
        property SM.ProductDetail productDetail: SM.ProductDetail {}
        property SM.ProductRetrain productRetrain: SM.ProductRetrain {}
        property SM.ProductTrainImages productTrainImages: SM.ProductTrainImages {}
        property SM.RunActive runActive: SM.RunActive {}
        property SM.RunCreate runCreate: SM.RunCreate {}
        property SM.RunDetail runDetail: SM.RunDetail {}
        property SM.RunExport runExport: SM.RunExport {}
        property SM.RunOverview runOverview: SM.RunOverview {}
        property SM.RunDetail runRecent: SM.RunDetail {}
        property SM.RunRecentOverview runRecentOverview: SM.RunRecentOverview {}
        property SM.Settings settings: SM.Settings {}
        property SM.Setup setup: SM.Setup {}
        property SM.SetupCameraMeasCalib setupCameraMeasCalib: SM.SetupCameraMeasCalib {}
        property SM.SetupCameraMeasCalibGallery setupCameraMeasCalibGallery: SM.SetupCameraMeasCalibGallery {}
        property SM.Status status: SM.Status {}
    }

    readonly property QtObject view: QtObject {
        readonly property bool loginConnectAddrIsLocalhost: ["127.0.0.1:3000", "localhost:3000"].includes(state.loginConnect.addr)

        // Returns true, if the login discovery is active.
        readonly property bool discoveryActive: state.loginDiscovery.callID > 0

        // Returns the camera with the given id.
        readonly property var camera: deviceID => state.cameras.find(c => c.deviceID === deviceID)

        // Returns the global anomaly class with the given id.
        readonly property var anomalyClassByID: classID => state.anomalyClasses.find(ac => ac.id === classID)

        // Returns a subset of the global anomaly classes filtered by the given ids.
        readonly property var anomalyClassesByIDs: ids => state.anomalyClasses.filter(ac => ids.indexOf(ac.id) !== -1)

        // Returns the product with the given id.
        readonly property var product: productID => state.products.find(p => p.id === productID)

        // Returns a subset of the global products filtered by the given name.
        readonly property var productsFilteredByName: name => state.products.filter(p => 
            p.name.toLowerCase().indexOf(name.toLowerCase()) !== -1
        )
        // Returns a subset of limit items of the current product's recent runs.
        readonly property var productMaxRecentRuns: limit => state.productDetail.recentRuns.slice(0, limit)

        // Returns true, if the pdf preview is currently being loaded.
        readonly property bool pdfPreviewLoading: state.pdfPreview.callID > 0
    }

    // Emitted when the fullscreen mode in the app options changes.
    // See main.qml's ApplicationWindow.visibility for why this is needed.
    signal fullscreenModeChanged()

    // Emitted when a page gets replaced.
    // This is needed so that the breadcrumbs can refresh.
    signal pageReplaced()

    // The dispatched signal is triggered by the Dispatcher for every action.
    // Each store can choose to react upon the dispatched action and update
    // its internal data, trigger further actions or middleware, etc.
    signal dispatched(string type, var data)

    // The consumed signal must be triggered whenever the store is done handling an action.
    signal consumed()

    onDispatched: function(type, data) {
        // Find the handler with longest matching prefix for the type.
        let longestPrefix = ""
        for (const prefix in _handlers) {
            if (prefix.length > longestPrefix.length && type.startsWith(prefix)) {
                longestPrefix = prefix
            }
        }
        if (longestPrefix === "") {
            // No handler found.
            consumed()
            return
        }
        const handler = _handlers[longestPrefix]

        // Retrieve the base function name from the type.
        let baseFuncName = type.substring(longestPrefix.length).lowercase()

        // Call all defined handler funcs for this action type.
        // If the action type has the special done suffix, it was emitted by the Api middleware. 
        // In this case, we want to call all defined handlers based on the special data that
        // is appended to the action data by the middleware.
        const doneSuffix = "Done"
        if (baseFuncName.endsWith(doneSuffix)) {
            baseFuncName = baseFuncName.substring(0, baseFuncName.length - doneSuffix.length)

            // Call special handlers, based on the result of the request.
            if (data.api.ok)       _callHandlerFuncIfDefined(handler, `${baseFuncName}Ok`,       _state, data)
            if (data.api.failed)   _callHandlerFuncIfDefined(handler, `${baseFuncName}Failed`,   _state, data)
            if (data.api.canceled) _callHandlerFuncIfDefined(handler, `${baseFuncName}Canceled`, _state, data)
            
            // Always call the done handler.
            _callHandlerFuncIfDefined(handler, `${baseFuncName}Done`, _state, data)
        } else if (handler.hasOwnProperty(baseFuncName)) {
            // Standard action.
            // Call with the current internal state.
            handler[baseFuncName](_state, data)
        } else {
            // Handler has method not defined.
            consumed()
            return
        }

        // Save current fullscreen mode to emit custom signal.
        const fullscreenMode = state.app.opts.fullscreenMode

        // Sync changes into public state to trigger property bindings.
        L.Obj.applyDiff(_state, state)

        // Emit custom signals.
        if (fullscreenMode !== state.app.opts.fullscreenMode) {
            root.fullscreenModeChanged()
        } else if (type === "navigationReplacePage") {
            root.pageReplaced()
        }

        // Action has been handled.
        consumed()
    }

    // Initializes the Store and registers it with the Dispatcher.
    // Must be called, before any Middleware has been initialized.
    function init() {
        // Copy public state into private state.
        L.Obj.copy(state, _state)
        // Save a copy of the initial state to reset parts of the state later.
        L.Obj.copy(state, IS.InitState)

        Dispatcher.registerStore(this)
    }

    //###############//
    //### Private ###//
    //###############//

    // The internal state.
    readonly property var _state: ({})

    // Handlers.
    readonly property var _handlers: ({
        "anomalyClass": AnomalyClass,
        "app": App,
        "camera": Camera,
        "cameraDetail": CameraDetail,
        "cameraFocus": CameraFocus,
        "classificationImage": ClassificationImage,
        "classificationImageCreate": ClassificationImageCreate,
        "classificationImageDetail": ClassificationImageDetail,
        "classificationImageOverview": ClassificationImageOverview,
        "dashboard": Dashboard,
        "dev": Dev,
        "eventDetail": EventDetail,
        "eventOverview": EventOverview,
        "global": Global,
        "help": Help,
        "helpNVision": HelpNVision,
        "helpResource": HelpResource,
        "login": Login,
        "loginConnect": LoginConnect,
        "loginDiscovery": LoginDiscovery,
        "navigation": Navigation,
        "notification": Notification,
        "pdfPreview": PDFPreview,
        "product": Product,
        "productCreate": ProductCreate,
        "productDetail": ProductDetail,
        "productOverview": ProductOverview,
        "productRetrain": ProductRetrain,
        "productTrainImages": ProductTrainImages,
        "run": Run,
        "runActive": RunActive,
        "runCreate": RunCreate,
        "runDetail": RunDetail,
        "runExport": RunExport,
        "runOverview": RunOverview,
        "runRecentDetail": RunRecentDetail,
        "runRecentOverview": RunRecentOverview,
        "settings": Settings,
        "setup": Setup,
        "setupCameraMeasCalib": SetupCameraMeasCalib,
        "setupCameraMeasCalibGallery": SetupCameraMeasCalibGallery,
        "state": SState,
        "status": Status,
    })

    function _callHandlerFuncIfDefined(handler, funcName, state, data) {
        if (handler.hasOwnProperty(funcName)) {
            handler[funcName](state, data)
        }
    }
}
