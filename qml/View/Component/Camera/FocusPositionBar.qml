import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Theme

Rectangle {
    id: root

    // The current Model.Camera object.
    required property var camera

    color: Theme.transparentBlack
    radius: 10
    implicitHeight: bar.implicitHeight + 2*Theme.spacingXS
    opacity: 0

    // The Progress bar unfortunately needs to strictly have its 'to' property set,
    // before we can correctly set its 'value'.
    // This requires us to manually assign them without a property binding to have full
    // control on the order in which the properties are assigned.
    onCameraChanged: {
        if (bar.to !== camera.focus.maxSteps) {
            bar.to = camera.focus.maxSteps
            anim.restart()
        }
        if (bar.value !== camera.focus.stepPos) {
            bar.value = camera.focus.stepPos
            anim.restart()
        }
    }

    OpacityAnimator {
        id: anim

        target: root
        from: 0.5
        to: 0
        duration: 3000
        easing.type: Easing.InQuint
    }

    ProgressBar {
        id: bar

        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
            margins: Theme.spacingM
        }
        from: 0

        Material.accent: "white"
    }
}