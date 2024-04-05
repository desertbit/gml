import QtQuick

import Theme

Rectangle {
    id: root

    property int count: 0

    // By default position it at the top right corner of its parent.
    x: parent.width - width
    width: 0
    radius: width/2
    color: Theme.colorAccent
    height: width

    states: [
        State {
            name: "visible"
            when: root.count > 0
            PropertyChanges { target: root; width: Math.max(label.implicitWidth, label.implicitHeight) + 4 }
            PropertyChanges { target: label; visible: true }
        }
    ]

    transitions: [
        Transition {
            from: ""
            to: "visible"
            SpringAnimation {
                properties: "width,height"
                spring: 5
                damping: 0.2
                epsilon: 0.25
                mass: 0.25
                duration: 200
            }
        }
    ]

    Text {
        id: label

        x: (parent.width / 2) - (width / 2) - 1
        anchors.verticalCenter: parent.verticalCenter
        color: Theme.colorOnAccent
        text: count
        visible: false
    }
}
