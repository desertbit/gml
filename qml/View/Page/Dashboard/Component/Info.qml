import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Store
import Theme

import View.Component.Container as VCC
import View.Component.Form as VCF

VCC.IconPane {
    id: root

    //: The computer device
    titleText: qsTr("Device")
    titleIconName: "server"
    spacing: Theme.spacingS

    RowLayout {
        spacing: Theme.spacingL

        ColumnLayout {
            spacing: Theme.spacingXS

            Components.LabCol {
                //: The computer host
                labelText: qsTr("Host")

                Components.Label { text: Store.state.nline.info.hostname }
            }

            Components.LabCol {
                //: The uptime of a computer system
                labelText: qsTr("Uptime")

                Components.Label { text: Store.state.nline.stats.upTime }
            }
        }

        Components.LabCol {
            //: The operating system kernel of a computer system.
            labelText: qsTr("Kernel")

            Layout.alignment: Qt.AlignTop

            Components.LabRow {
                labelText: qsTr("Version:")

                Layout.leftMargin: Theme.spacingS

                Components.Label { text: Store.state.nline.info.kernel.version }
            }

            Components.LabRow {
                //: The computer architecture (e.g. x86_64)
                labelText: qsTr("Architecture:")

                Layout.leftMargin: Theme.spacingS

                Components.Label { text: Store.state.nline.info.kernel.arch }
            }
        }
    }

    VCF.HorDivider {}

    RowLayout {
        spacing: Theme.spacingL

        Components.LabCol {
            //: The total computer memory.
            labelText: qsTr("Memory")

            Components.Label { text: Store.state.nline.info.totalMemory }
        }

        Components.LabCol {
            //: The total computer storage.
            labelText: qsTr("Storage")

            Components.Label { text: Store.state.nline.info.totalStorage }
        }
    }

    VCF.HorDivider {}

    RowLayout {
        Components.LabCol {
            //: The central processing unit.
            labelText: qsTr("CPU")

            Components.LabRow {
                //: The amount of physical cores of the CPU.
                labelText: qsTr("Physical Cores:")

                Layout.leftMargin: Theme.spacingS

                Components.Label { text: Store.state.nline.info.cpu.physCores; Layout.fillWidth: true }
            }

            Components.LabRow {
                //: The amount of logical cores of the CPU.
                labelText: qsTr("Logical Cores:")

                Layout.leftMargin: Theme.spacingS

                Components.Label { text: Store.state.nline.info.cpu.logCores }
            }

            Components.LabRow {
                //: The cache of the CPU.
                labelText: qsTr("Cache Size:")

                Layout.leftMargin: Theme.spacingS

                Components.Label { text: Store.state.nline.info.cpu.cacheSize }
            }
        }

        Components.LabCol {
            //: The graphics processing unit.
            labelText: qsTr("GPU")

            Components.LabRow {
                //: The version of the gpu driver.
                labelText: qsTr("Driver:")

                Layout.leftMargin: Theme.spacingS

                Components.Label { text: Store.state.nline.info.gpu.driverVersion; Layout.fillWidth: true }
            }

            Components.LabRow {
                //: The version of the CUDA toolkit.
                labelText: qsTr("CUDA:")

                Layout.leftMargin: Theme.spacingS

                Components.Label { text: Store.state.nline.info.gpu.cudaVersion }
            }

            Components.LabRow {
                //: The number of gpu devices.
                labelText: qsTr("Devices:")

                Layout.leftMargin: Theme.spacingS

                Components.Label { text: Store.state.nline.info.gpu.devices.length }
            }
        }
    }

    Item {
        Layout.fillWidth: true
        Layout.fillHeight: true
    }
}
