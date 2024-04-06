import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action as A
import Lib as L
import Store
import Theme

BasePane {
    id: root

    // Emitted, when the user wants to download the manual onto a storage device.
    signal saveToStorage()

    title: qsTr("Manual")
    description: qsTr("The manual contains explanations and details to all topics around nLine and its UI application nVision.")
    icon: "book"

    onViewClicked: A.APDFPreview.viewResource(L.Con.Resource.Manual)
    onDownloadClicked: {
        if (Store.state.app.opts.withStorageDevices) {
            root.saveToStorage()
        } else {
            A.AHelpResource.download(L.Con.Resource.Manual, Store.state.locale)
        }
    }
}
