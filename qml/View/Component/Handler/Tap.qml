import QtQuick

// This tap handler simply consumes the event by default.
TapHandler {
    // This prevents the event from bubbling up the chain.
    // See https://forum.qt.io/topic/127002/taphandler-stop-propagation/4
    gesturePolicy: TapHandler.ReleaseWithinBounds
}