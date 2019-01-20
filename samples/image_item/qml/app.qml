import QtQuick 2.11
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4

import Gml 1.0

ApplicationWindow {
    id: window
    width: 300
    height: 300
    visible: true

    ImageItem {
        id: imageItem
        source: "cage"
        height: parent.height
        width: parent.width
    }
}