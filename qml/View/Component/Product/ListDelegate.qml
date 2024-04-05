import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action
import Lib as L
import Theme
import Store

import View.Component.Button as VCB
import View.Component.Handler as VCH
import View.Component.Icon as VCI
import View.Component.Image as VCImg

// To be used as delegate in e.g. a ListView or Repeater.
// Width and height must be set.
Rectangle {
    id: root

    required property int index
    required property var modelData  // Model.Product

    // The inset of the left and right edges.
    property real inset: 0
    // Enables the select mode.
    property bool selectMode: false
    // When true, the background color starts at the second color for the first item.
    property bool invertBackgroundColorOrder: false

    // Emitted when the user presses the delete button.
    signal deleted(int id)
    // Emitted when the user presses the info button.
    signal info(int id)
    // Emitted when the user presses the runs button.
    signal selectedRuns(int id)
    // Emitted when the user clicks anywhere else on the delegate.
    signal tapped(int id)

    color: hover.hovered
           ? Theme.listDelegateBackgroundHighlight
           : (index % 2 === (invertBackgroundColorOrder ? 1 : 0) ? Theme.listDelegateBackground1 : Theme.listDelegateBackground2)

    states: [
        State {
            name: "selectMode"
            when: root.selectMode
            PropertyChanges { target: info; visible: true }
            PropertyChanges { target: created; visible: false }
            PropertyChanges { target: updated; visible: false }
            PropertyChanges { target: description; visible: false }
            PropertyChanges { target: update; visible: false }
            PropertyChanges { target: runs; visible: false }
            PropertyChanges { target: deleter; visible: false }
        }
    ]

    RowLayout {
        anchors {
            fill: parent
            topMargin: 4
            bottomMargin: 4
            leftMargin: root.inset
            rightMargin: root.inset
        }
        spacing: Theme.spacingL

        VCB.RoundIconButton {
            id: info

            fontIcon.name: "info"
            flat: true
            visible: false

            onClicked: root.info(root.modelData.id)
        }

        VCImg.Image {
            source: root.modelData.thumbnailSource
            fillMode: Image.PreserveAspectFit

            Layout.fillHeight: true
            Layout.preferredWidth: height*2.5
        }

        ColumnLayout {
            spacing: Theme.spacingXXS

            Layout.preferredWidth: 275
            Layout.maximumWidth: 275
            Layout.rightMargin: parent.spacing

            Text {
                font {
                    weight: Font.DemiBold
                    pixelSize: Theme.fontSizeXL
                }
                text: root.modelData.name
                elide: Text.ElideRight

                Layout.leftMargin: -Theme.spacingM
            }

            Text {
                id: created

                font.pixelSize: Theme.fontSizeM
                color: Theme.colorForegroundTier2
                text: qsTr("Created on %1").arg(root.modelData.created.formatDateTime(Store.state.locale))
                elide: Text.ElideRight
            }

            Text {
                id: updated

                font.pixelSize: Theme.fontSizeM
                color: Theme.colorForegroundTier2
                text: qsTr("Updated on %1").arg(root.modelData.updated.formatDateTime(Store.state.locale))
                elide: Text.ElideRight
            }
        }

        Text {
            id: description

            font.pixelSize: Theme.fontSizeM
            text: !!root.modelData.description ? qsTr("Description: \n%1").arg(root.modelData.description) : ""
            elide: Text.ElideRight
            maximumLineCount: 5
            wrapMode: Text.WordWrap

            Layout.fillWidth: true
            Layout.maximumWidth: 1000
        }

        // Filler
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        Text {
            font.pixelSize: Theme.fontSizeM
            color: Theme.colorForegroundTier2
            text: qsTr("ID: %1").arg(root.modelData.id)
            elide: Text.ElideRight
        }

        ColumnLayout {
            id: update

            visible: root.modelData.updateAvailable

            VCI.Icon {
                name: root.modelData.updateRequired ? "alert-triangle" : "alert-circle"
                color: Material.color(root.modelData.updateRequired ? Material.Orange : Material.Blue)
                size: Theme.fontSizeXL

                Layout.alignment: Qt.AlignHCenter
            }
            Text {
                text: root.modelData.updateRequired ? qsTr("Update required") : qsTr("Update available")
            }
        }

        VCB.RoundIconButton {
            id: runs

            fontIcon.name: "activity"
            flat: true

            onClicked: root.selectedRuns(root.modelData.id)
        }

        VCB.RoundIconButton {
            id: deleter

            fontIcon.name: "trash-2"
            flat: true

            onClicked: root.deleted(root.modelData.id)
        }
    }

    HoverHandler {
        id: hover
    }

    VCH.Tap {
        onTapped: root.tapped(root.modelData.id)
    }
}
