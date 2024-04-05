import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Action.RunExport as ARunExport

import Lib as L
import Store
import Theme

import View.Component.Button as VCB
import View.Component.Container as VCC
import View.Component.Device as VCDev
import View.Component.Icon as VCI

VCC.IconPane {
    id: root

    titleText: qsTr("Report")
    titleIconName: "file-text"
    titleIconColor: Theme.colorExport
    contentSpacing: Theme.spacingM

    // Unfortunately we currently can not move this dialog into the App middleware, since it triggers
    // actions itself and is therefore not suited for the action interception we do inside App.
    VCDev.StorageDeviceDialog {
        id: dialog

        anchors.centerIn: Overlay.overlay
        title: qsTr("Please choose a storage device to save the file to.")
        modal: true

        onSelected: storageDeviceID => ARunExport.saveToStorage(
            Store.state.runExport.runs.map(r => r.id), Store.state.locale, storageDeviceID, html.checked, pdf.checked, csv.checked
        )
    }

    Text {
        text: qsTr("A report contains all vital information of a batch, including its events with images.") + "\n" +
              qsTr("The final zip archive includes the selected formats for all batches.")
        font {
            pixelSize: Theme.fontSizeL
        }
        wrapMode: Text.WordWrap

        Layout.fillWidth: true
    }

    ColumnLayout {
        Text {
            //: As in a file format, e.g. '.pdf' or '.html' or '.csv'
            text: qsTr("Formats:")
            font {
                pixelSize: Theme.fontSizeM
                weight: Font.DemiBold
            }
        }

        ColumnLayout {
            spacing: 0

            Layout.leftMargin: Theme.spacingS

            CheckBox {
                id: html

                text: qsTr("HTML")
                checked: true
                font.pixelSize: Theme.fontSizeL
            }

            CheckBox {
                id: pdf

                text: qsTr("PDF")
                checked: true
                font.pixelSize: Theme.fontSizeL
            }

            CheckBox {
                id: csv

                text: qsTr("CSV")
                font.pixelSize: Theme.fontSizeL
            }
        }
    }

    // Warn message for large exports.
    Text {
        font {
            pixelSize: Theme.fontSizeL
            weight: Font.DemiBold
            italic: true
        }
        //: An export can severely impact the performance of the analysis of the active batch, which this message warns the user of.
        text: qsTr("Please note that an export can have an effect on the analysis speed of the active batch, which can result in gaps in its sampling.") + "\n" +
              qsTr("To guarantee a full coverage of the batch, it is best to defer exports until after it has finished.")
        wrapMode: Text.WordWrap

        Layout.fillWidth: true
    }

    // Warn message for exports to storage drives.
    RowLayout {
        spacing: Theme.spacingXS
        visible: Store.state.app.opts.withStorageDevices

        VCI.Icon {
            name: "alert-triangle"
            color: Theme.warning
            size: Theme.fontSizeXL

            Layout.alignment: Qt.AlignTop
        }

        Text {
            font {
                pixelSize: Theme.fontSizeL
                weight: Font.DemiBold
            }
            text: qsTr("Please do not remove the drive while the report is generated.")

            Layout.fillWidth: true
        }
    }

    VCB.Button {
        highlighted: true
        text: qsTr("Export")
        horizontalPadding: Theme.spacingL
        enabled: html.checked || pdf.checked || csv.checked

        Layout.topMargin: Theme.spacingM

        onClicked: {
            if (Store.state.app.opts.withStorageDevices) {
                dialog.open()
            } else {
                ARunExport.download(Store.state.runExport.runs.map(r => r.id), Store.state.locale, html.checked, pdf.checked, csv.checked)
            }
        }
    }

    Item { Layout.fillHeight: true } // Filler.
}
