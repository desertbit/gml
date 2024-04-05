import QtQuick

import Lib as L

QtObject {
    property int productID: 0

    // Contains Model.Run objects.
    property var page: []
    property int totalCount: 0
    property int filteredCount: 0
    property Cursor cursor: Cursor {}
    property int limit: 0

    // The Api request data used to request the run pages.
    property QtObject filter: QtObject {
        property string name: ""
        property date afterTS: L.LDate.Invalid
        property date beforeTS: L.LDate.Invalid
    }

    // If true, the user skipped the ProductDetail page.
    property bool skippedProductDetail: false
    property string skippedProductName: ""
}
