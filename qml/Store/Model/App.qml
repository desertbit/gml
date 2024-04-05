import QtQuick

QtObject {
    property bool showAdvancedOptions: false
    property bool versionOutdated: false

    // Contains page constants defined in L.Con.Page.
    // Topmost page comes first for faster access.
    property var pages: []
    // If true, the breadcrumb navigation is displayed.
    property bool showBreadcrumbNavigation: true
    // The index relative to the view stack from which page on
    // we want to show breadcrumbs.
    // Right now, this is used to omit the login page after successfully
    // connecting to a nLine device.
    property int breadcrumbsStartIndex: 0

    property bool showNotifications: false
    property bool showSettings: false

    property QtObject opts: QtObject {
        property string autoLoginAddr: ""
        property bool debugMode: false
        property bool demoMode: false
        property bool devMode: false
        property bool disableVersionCheck: false
        property bool fullscreenMode: false
        property bool withAutoLogin: false
        property bool withStorageDevices: false
        property bool withVirtualKeyboard: false
        property bool verbose: false
    }
}
