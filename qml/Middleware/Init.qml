pragma Singleton

import QtQuick

import Dispatcher

import "Api"
import "App"
import "Log"
import "Router"

// The Init singleton takes care of registering our middlewares with the dispatcher.
// After the initialization phase is over, it has no further use.
//
// To add a new middleware, create a QML module in this directory.
// It must contain one Component that uses the "Base" as root Component, where
// the dispatched signal is handled and the next signal gets emitted.
//
// Middlewares may decide whether they modify / defer / remove incoming actions
// and / or insert new ones.
QtObject {
    // init triggers the initialization of the singleton.
    // Should be called from the main QML file.
    // Args:
    //  - window(ApplicationWindow) : The main application window.
    //  - stack(StackView)          : The main stack.
    function init(window, stack) {
        api.init(window)
        app.init(window)
        router.init(window, stack)
    }

    readonly property Api api: Api {}
    readonly property App app: App {}
    readonly property Log log: Log {}
    readonly property Router router: Router {}

    Component.onCompleted: {
        // The order of registration is important!
        Dispatcher.registerMiddleware(log)
        Dispatcher.registerMiddleware(app)
        Dispatcher.registerMiddleware(api)
        Dispatcher.registerMiddleware(router)
    }
}
