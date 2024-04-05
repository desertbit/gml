import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts


import Theme

BasePane {
    id: root

    title: qsTr("Quick-start guide")
    description: qsTr("The quick-start guide aims to get operators quickly up to speed with nLine and nVision.")
    icon: "file-text"

    onViewClicked: console.log("todo: show pdf preview")
    onDownloadClicked: console.log("todo: download")
}
