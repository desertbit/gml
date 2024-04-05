import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action.App as AApp
import Action.Navigation as ANavigation

import Lib as L
import Middleware as Middleware
import Store
import Theme

import View.Component.ToolBar as VCT
import View.Component.VirtualKeyboard as VCVK

import View.Page.Status as VPStat

import "main.js" as Logic

ApplicationWindow {
    id: root

    width: 1920
    height: 1080
    visible: true

    Material.theme: Theme.theme
    Material.primary: Theme.colorPrimary
    Material.accent: Theme.colorAccent
    Material.foreground: Theme.colorForeground
    Material.background: Theme.colorBackground

    // Application initialization.
    Component.onCompleted: {
        // Initialize the store first.
        Store.init()
        // Initialize middlewares.
        Middleware.Init.init(root, stack)
        // Request the runtime options.
        AApp.loadRuntimeOptions()
        // Load the settings.
        AApp.loadSettings()
    }

    header: VCT.ToolBar {
        height: Theme.toolbarHeight

        fixedLeftContent: VCT.Breadcrumbs {
            id: breadcrumbs

            visible: Store.state.app.showBreadcrumbNavigation
            model: stack.depth - Store.state.app.breadcrumbsStartIndex
            delegate: VCT.BreadcrumbDelegate {
                // Last element is always highlighted.
                highlighted: breadcrumbs.model-1 === index
                // Retrieve title from Page component.
                text: stack.get(index + Store.state.app.breadcrumbsStartIndex).title

                // Pop all pages above the selected.
                onSelected: ANavigation.popPage(breadcrumbs.model - 1 - index)
            }

            onBackPressed: ANavigation.popPage()
        }
    }

    Connections {
        target: Store

        function onPageReplaced() {
            // Reassign the property binding to trigger it.
            breadcrumbs.model = 0
            breadcrumbs.model = Qt.binding(() => stack.depth - Store.state.app.breadcrumbsStartIndex)
        }

        function onFullscreenModeChanged() {
            root.visibility = Store.state.app.opts.fullscreenMode ? "FullScreen" : "Windowed"
        }
    }

    // We provide our own custom background, so we can slightly change the base background color
    // without affecting all child components of the ApplicationWindow.
    Rectangle {
        anchors.fill: parent
        color: Theme.colorAppBackground
    }

    StackView {
        id: stack

        width: parent.width
        height: parent.height
        focus: true
    }

    // This tap handler catches all unhandled tap events and moves the focus to the current stack item.
    // This causes other controls to lose focus, when the user clicks elsewhere, which
    // also makes sure that the virtual keyboard can be closed this way.
    TapHandler {
        onTapped: {
            stack.currentItem.focus = true
        }
    }

    VCVK.InputPanel {
        id: input

        anchors {
            left: parent.left
            right: parent.right
            margins: Theme.spacingXXL*2
        }
        y: Qt.inputMethod.visible ? parent.height - height : parent.height
        z: 100
        enabled: visible
        visible: Store.state.app.opts.withVirtualKeyboard
    }

    // Ensure the focused item is inside the viewport when using an input panel.
    onActiveFocusItemChanged: Logic.handleInputPanelViewport()

    // We need to listen on the input method as well, since the visibility might change after the
    // active focus item has changed. This causes the active focus item change handler to not move
    // the view into the view port, since the input method still reports it is not visible.
    Connections {
        target: Qt.inputMethod

        function onVisibleChanged() { Logic.handleInputPanelViewport() }
    }
}
