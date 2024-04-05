import QtQuick

import View.Component.Button as VCB

VCB.ToolIconButton {
    id: root

    signal triggered()

    fontIcon.name: "refresh-ccw"

    onClicked: {
        triggered()
        anim.restart()
    }

    RotationAnimator {
        id: anim

        target: root
        from: 0
        to: 180
        duration: 200
        direction: RotationAnimator.Counterclockwise
    }
}
