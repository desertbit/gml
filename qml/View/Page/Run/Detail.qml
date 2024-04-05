import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Store

import "Component/Detail"

DetailPage {
    id: root

    model: Store.state.runDetail
    showViewProduct: false
}
