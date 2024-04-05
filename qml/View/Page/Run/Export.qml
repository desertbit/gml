import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Theme

import View.Component.Container as VCC

import "Component/Export"

VCC.Page {
    id: root

    title: qsTr("Export")

    QtObject {
        id: _

        readonly property real paneHalfWidth: (content.width / 2) - (content.spacing / 2)
    }

    RowLayout {
        id: content

        anchors {
            fill: parent
            margins: Theme.spacingS
        }
        spacing: anchors.margins

        RunsPane {
            Layout.preferredWidth: _.paneHalfWidth
            Layout.fillHeight: true
        }

        ExportPane {
            Layout.preferredWidth: _.paneHalfWidth
            Layout.fillHeight: true
        }
    }
}
