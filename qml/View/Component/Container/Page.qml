import QtQuick

Item {
    id: root

    // This title is shown in the breadcrumbs navigation.
    required property string title

    // If true, the router will show a dialog asking the user
    // if he wants to discard the unsaved changes.
    property bool hasUnsavedChanges: false
}
