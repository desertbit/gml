pragma Singleton

import QtQuick

import Lib as L

Item {
    id: root

    // registerStore registers the given store with the Dispatcher.
    // The store will receive all dispatched actions after the registered middlewares
    // have processed them.
    // Args:
    //  - store(Store) : The QtObject store that must have Store as its root Component.
    function registerStore(store) {
        if (!L.Obj.hasFunc(store, "dispatched") || !L.Obj.hasFunc(store, "consumed")) {
            L.Log.error("Dispatcher.registerStore", `${store} is missing the dispatched or consumed signal`)
            return
        }

        _.store = store
        _.store.consumed.connect(_.dispatchDone)
        console.debug("Dispatcher.registerStore: registered", store)
    }

    // registerMiddleware registers the given middleware with the Dispatcher.
    // The middleware will receive all dispatched actions before every registered store,
    // but after every middleware that was registered beforehand.
    // Args:
    //  - middle(Middleware) : The middleware Component that must have a dispatched and next signal.
    function registerMiddleware(middle) {
        if (!L.Obj.hasFunc(middle, "dispatched") || !L.Obj.hasFunc(middle, "consumed") || !L.Obj.hasFunc(middle, "next")) {
            L.Log.error("Dispatcher.registerMiddleware", `${middle} is missing the dispatched, consumed or next signal`)
            return
        }

        // Connect the currently last middleware with the new one.
        if (!_.middlewaresEmpty) {
            const last = _.middlewares[_.middlewares.length-1]
            last.next.disconnect(_.store.dispatched)
            last.next.connect(middle.dispatched)
        }

        // Connect the new middleware with the store.
        middle.next.connect(_.store.dispatched)
        middle.consumed.connect(_.dispatchDone)

        // Store the new middleware in our list.
        _.middlewares.push(middle)
        console.debug("Dispatcher.registerMiddleware: registered", middle)
    }

    // dispatch dispatches the given action type along with its data to all registered Middlewares.
    // Middlewares may modify, defer, remove or insert further actions.
    // After all middlewares have processed the action, it gets dispatched to every registered store.
    // Args:
    //  - type(string)        : The action type. Usually a constant from action.js.
    //  - data(object)        : The action data.
    //  - promiseOnDone(bool) : If true, the returned Promise is resolved, when a separate action with type
    //                          "${type}Done" has finished its dispatch. This is useful to await the result
    //                          of an action that performs an Api request in our middleware.
    function dispatch(type, data, promiseOnDone=false) {
        // DEBUG: Uncomment this line and the corresponding one in dispatchDone() to see execution times per action.
        //console.time(type)

        // Currently, every promise is guaranteed to be resolved.
        return new Promise(function(resolve, reject) {
            // Add this action to the queue.
            _.dispatchQueue.push({
                type: type,
                data: data,
                resolve: resolve,
                promiseOnDone: promiseOnDone
            })

            // If there was already an action processing in the queue, do nothing for now.
            if (_.dispatchQueue.length > 1) {
                return
            }

            // The queue was empty, directly start processing this action.
            _.dispatchToFirstHandler(type, data)
        })
    }

    //###############//
    //### Private ###//
    //###############//

    QtObject {
        id: _

        // Returns true, if no middleware has been registered yet.
        readonly property bool middlewaresEmpty: middlewares.length === 0

        // The registered store.
        property QtObject store
        // The registered middlewares.
        property list<QtObject> middlewares
        // The queue of dispatched actions.
        // Allows to sequentially process the actions with the benefit of signal responsiveness.
        property var dispatchQueue: []
        // Stores resolve functions of promises that should be delayed until the action's done signal has arrived.
        // The key of this map is the awaited action type, so usually "${originalAction.type}Done".
        // The value is the resolve function of the original action's promise.
        property var donePromises: ({})

        // dispatchToFirstHandler triggers a dispatched signal on the first registered middleware or store
        // with the given type and data.
        // Args:
        //  - type(string)      : The action type. Usually a constant from action.js.
        //  - data(object|null) : The action data.
        function dispatchToFirstHandler(type, data) {
            // Dispatch the action to the first middleware.
            // It will automatically send it to subsequent middlewares, until the action
            // is dispatched to the store.
            // If there is no middleware registered, dispatch directly to the store.
            if (middlewaresEmpty) {
                store.dispatched(type, data)
            } else {
                middlewares[0].dispatched(type, data)
            }
        }

        // dispatchDone removes the currently processed action from the dispatch queue.
        // If the queue is not yet empty, the next action gets processed.
        function dispatchDone() {
            // Remove current action from the front.
            let action = dispatchQueue.shift()

            if (action.promiseOnDone) {
                // If the action's promise should be resolved once its done signal has arrived,
                // store the resolve function temporarily in our internal map.
                donePromises[`${action.type}Done`] = action.resolve
            } else {
                // Resolve the action's promise directly.
                action.resolve(action.data)
            }

            // Resolve promises waiting for their done action.
            if (action.type.endsWith("Done") && donePromises.hasOwnProperty(action.type)) {
                donePromises[action.type](action.data) // resolve()
                delete donePromises[action.type]
            }

            if (dispatchQueue.length > 0) {
                // Trigger next waiting action.
                action = dispatchQueue[0]
                dispatchToFirstHandler(action.type, action.data)
            }

            // DEBUG: Uncomment this line and the corresponding one in dispatch() to see execution times per action.
            //console.timeEnd(action.type)
        }
    }
}
