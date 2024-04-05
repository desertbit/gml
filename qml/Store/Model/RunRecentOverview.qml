import QtQuick

import Lib as L

QtObject {
    // Contains Model.Run objects.
    property var page: []
    property int totalCount: 0
    property int filteredCount: 0
    property Cursor cursor: Cursor {}
    property int limit: 0

    // The Api request data used to request the run pages.
    property QtObject filter: QtObject {
        property string productName: ""
        property string runName: ""
        property date afterTS: L.LDate.Invalid
        property date beforeTS: L.LDate.Invalid
    }
}
