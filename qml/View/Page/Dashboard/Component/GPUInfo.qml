import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Store
import Theme

import View.Component.Container as VCC

VCC.IconPane {
    id: root

    //: A graphics processing unit.
    titleText: qsTr("GPU")
    titleIconName: "monitor"
    spacing: Theme.spacingS

    GridLayout {
        columns: 2

        Repeater {
            model: Store.state.nline.stats.gpus

            delegate: Components.LabCol {
                //: The nth graphics processing unit.
                labelText: qsTr("GPU %L1").arg(index+1)

                Components.LabRow {
                    //: The graphics processung unit.
                    labelText: qsTr("GPU:")

                    Layout.leftMargin: Theme.spacingS

                    Components.Label {
                        text: `${modelData.util} %`

                        Layout.fillWidth: true
                    }
                }

                Components.LabRow {
                    //: The GPU VRAM
                    labelText: qsTr("Memory:")

                    Layout.leftMargin: Theme.spacingS

                    Components.Label {
                        text: `${modelData.memoryUtil} %`
                    }
                }

                Components.LabRow {
                    //: The GPU video encoder chip.
                    labelText: qsTr("Encoder:")

                    Layout.leftMargin: Theme.spacingS

                    Components.Label {
                        text: `${modelData.encoderUtil} %`
                    }
                }

                Components.LabRow {
                    //: The GPU video decoder chip.
                    labelText: qsTr("Decoder:")

                    Layout.leftMargin: Theme.spacingS

                    Components.Label {
                        text: `${modelData.decoderUtil} %`
                    }
                }
            }
        }
    }

    Item {
        Layout.fillWidth: true
        Layout.fillHeight: true
    }
}
