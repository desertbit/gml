import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Lib as L
import Store
import Theme

import View.Component.Handler as VCH
import View.Component.Icon as VCI
import View.Component.List as VCL

ScrollView {
    id: root

    // A js array containing the numeric ids of the selected classes.
    readonly property var selectedClassIDs: () => _.selector.selectedIDs()

    // If greater than 0, the selection is restricted to max items.
    property int max: 0

    function selectClassIDs(...classIDs) {
        _.selector.deselectAll()
        _.selector.select(...classIDs)
    }

    clip: true
    contentWidth: content.implicitWidth + ScrollBar.vertical.width + 5

    QtObject {
        id: _

        readonly property VCL.Selector selector: VCL.Selector {}
    }

    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

    GridLayout {
        id: content

        columns: 4
        columnSpacing: Theme.spacingXS
        rowSpacing: Theme.spacingXS

        Repeater {
            model: Store.state.anomalyClasses.filter(ac => ac.id !== L.Con.AnomalyClass.Unclassified)

            BoxDelegate {
                id: delegate

                readonly property bool selected: _.selector.selected(modelData.id, _.selector.numSelected)

                padding: 8
                font.pixelSize: Theme.fontSizeL
                hoverEnabled: true

                Rectangle {
                    anchors.fill: delegate
                    radius: delegate.padding
                    color: "#99999999"
                    visible: _.selector.numSelected > 0 && !delegate.selected
                }

                VCH.Tap {
                    onTapped: {
                        if (delegate.selected) {
                            _.selector.deselect(delegate.modelData.id)
                            return
                        }

                        // Prevent selecting more items than allowed.
                        if (root.max > 0 && _.selector.numSelected === root.max) {
                            // Handle the special case if max is 1.
                            // We then want to allow switching from the currently selected class to a new
                            // one by one button press on the new class, instead of first having to
                            // deselect the current class.
                            if (root.max !== 1) {
                                return
                            }
                            _.selector.deselectAll()
                        }
                        
                        _.selector.select(delegate.modelData.id)
                    }
                }
            }
        }
    }
}
