import QtQuick

import View.Component.Button as VCB

VCB.RoundIconButton {
    id: root

    signal triggered()

    fontIcon.name: "refresh-cw"

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
        direction: RotationAnimator.Clockwise
    }
}
