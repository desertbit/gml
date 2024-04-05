import QtQuick

QtObject {
    // The dispatched signal is triggered by the Dispatcher for every action.
    // Each middleware can choose to react upon the action and modify / defer / remove
    // it and / or dispatch new actions.
    signal dispatched(string type, var data)

    // The consumed signal must be triggered whenever the middleware wants to
    // consume an action instead of forwarding it via next.
    signal consumed()

    // The next signal is emitted, when a middleware is done handling an action.
    signal next(string type, var data)
}
