import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts


import Lib as L
import Store
import Theme

import View.Component.Button as VCB
import View.Component.Container as VCC
import View.Component.Date as VCD
import View.Component.Form as VCF
import View.Component.List as VCL
import View.Component.Run as VCR

Page {
    id: root

    property Item headerItem

    property alias content: contentItem.children
    
    property alias actions: actionColumn.children

    property alias nonAvailableMessage: nonAvailableLabel.text

    // The item selector.
    readonly property VCL.Selector selector: VCL.Selector {}

    states: [
        State {
            name: "atLeastOneSelected"
            when: selector.numSelected > 0
            extend: "selection"
            PropertyChanges { target: actionColumn; width: Math.max(implicitWidth, 140); anchors.margins: Theme.spacingXS }
            PropertyChanges { target: contentItem; anchors.rightMargin: Theme.spacingXS }
        },
        State {
            name: "selection"
            when: selector.selectionMode
            PropertyChanges { target: selectionCancel; visible: true }
        }
    ]
    transitions: [
        Transition {
            to: "selection"
            NumberAnimation { target: actionColumn; duration: 100; property: "width" }
        },
        Transition {
            from: "selection"
            NumberAnimation { target: actionColumn; duration: 100; property: "width" }
        }
    ]

    Component.onCompleted: {
        if (headerItem) {
            headerItem.parent = contentItem.parent
            headerItem.anchors.top = Qt.binding(() => headerItem.parent.top)
            headerItem.anchors.left = Qt.binding(() => headerItem.parent.left)
            headerItem.anchors.right = Qt.binding(() => headerItem.parent.right)
        }
        if (contentItem.children.length === 1) {
            contentItem.children[0].anchors.fill = Qt.binding(() => contentItem)
        }
    }

    Item {
        id: contentItem

        anchors {
            top: root.headerItem && root.headerItem.parent === contentItem.parent ? headerItem.bottom : parent.top
            left: parent.left
            right: actionColumn.left
            bottom: parent.bottom
        }
    }

    VCC.WidestItemColumnLayout {
        id: actionColumn

        anchors {
            top: root.headerItem && root.headerItem.parent === contentItem.parent ? headerItem.bottom : parent.top
            right: parent.right
            bottom: parent.bottom
        }
        width: 0
        visible: width > 0
    }

    // No run available message.
    Text {
        id: nonAvailableLabel

        anchors.centerIn: contentItem
        font.pixelSize: Theme.fontSizeXL
        color: Theme.colorForegroundTier2
        visible: !!text
    }
}
