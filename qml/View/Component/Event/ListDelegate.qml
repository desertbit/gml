import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Lib as L
import Theme
import Store

import View.Component.AnomalyClass as VCA
import View.Component.Button as VCB
import View.Component.Handler as VCH
import View.Component.Image as VCImg

// To be used as delegate in e.g. a ListView or Repeater.
// Width and height must be set.
Rectangle {
    id: root

    required property var modelData // Model.Event
    required property int index

    // The inset of the left and right edges.
    property real inset: 0
    // When true, the background color starts at the second color for the first item.
    property bool invertBackgroundColorOrder: false

    // Emitted when the user clicks anywhere else on the delegate.
    signal tapped(int id)

    color: hover.hovered
           ? Theme.listDelegateBackgroundHighlight
           : (index % 2 === (invertBackgroundColorOrder ? 1 : 0) ? Theme.listDelegateBackground1 : Theme.listDelegateBackground2)

    RowLayout {
        anchors {
            fill: parent
            topMargin: 2
            bottomMargin: 2
            leftMargin: root.inset
            rightMargin: root.inset
        }
        spacing: Theme.spacingM

        VCImg.Image {
            cache: true
            source: root.modelData.thumbnailSource
            fillMode: Image.PreserveAspectFit

            Layout.fillHeight: true
            Layout.preferredWidth: Math.floor(height*2.5)
        }

        Rectangle {
            border {
                width: 1
                color: "black"
            }
            color: L.Event.codeColor(root.modelData.code)
            radius: width/2

            Layout.preferredWidth: 30
            Layout.preferredHeight: width
            Layout.alignment: Qt.AlignVCenter
        }

        ColumnLayout {
            spacing: Theme.spacingXXS

            Layout.rightMargin: root.inset

            Text {
                font {
                    weight: Font.DemiBold
                    pixelSize: Theme.fontSizeM
                }
                text: L.Event.codeName(root.modelData.code)
            }

            Text {
                id: ts

                font.pixelSize: Theme.fontSizeM
                color: Theme.colorForegroundTier2
                text: root.modelData.ts.formatDateTime(Store.state.locale)
            }
        }

        ColumnLayout {
            spacing: Theme.spacingXXS

            Text {
                font {
                    weight: Font.DemiBold
                    pixelSize: Theme.fontSizeM
                }
                text: root.modelData.code === L.Event.Code.Error ? L.Event.errCodeName(root.modelData.errCode) : ""
                elide: Text.ElideRight

                Layout.fillWidth: true
            }

            Row {
                spacing: Theme.spacingXXS

                Text {
                    font.pixelSize: Theme.fontSizeM
                    color: Theme.colorForegroundTier2
                    //: Hashtag as counter.
                    text: qsTr("#%L1").arg(root.modelData.num)
                }

                Text {
                    font.pixelSize: Theme.fontSizeM
                    color: Theme.colorForegroundTier2
                    //: m is the abbreviation for meter
                    text: qsTr("%L1 m").arg(L.LMath.roundToFixed(root.modelData.position/100, 2))
                }
            }
        }

        ColumnLayout {
            Layout.rightMargin: Theme.spacingXS
            layoutDirection: Qt.RightToLeft

            Row {
                spacing: Theme.spacingXXXS

                Repeater {
                    // Filter the anomaly boxes to get the distinct anomaly classes.
                    model: root.modelData.code !== L.Event.Code.Defect ? [] : root.modelData.anomalyBoxes.
                            map(b => Store.view.anomalyClassByID(b.anomalyClassID)).
                            filter((value, index, self) => index === self.findIndex(c => (c.id === value.id)))

                    delegate: VCA.BoxDelegate {}
                }
            }

            Label {
                background: Rectangle {
                    radius: 5
                    color: Theme.colorAnomalyClass
                }
                padding: Theme.spacingXXXS
                color: Theme.colorOnAnomalyClass
                text: qsTr("Has classification image")
                font {
                    pixelSize: Theme.fontSizeS
                    weight: Font.DemiBold
                }
                visible: root.modelData.usedAsCustomTrainImage
            }
        }

        ColumnLayout {
            spacing: 0
            visible: root.modelData.code === L.Event.Code.MeasureDrift

            Layout.leftMargin: Theme.spacingS
            Layout.rightMargin: Theme.spacingS

            //: Minimum diameter with millimeter as unit.
            Text {
                text: qsTr("Min.: %L1mm").arg(L.LMath.roundToFixed(root.modelData.measurePoint.min.diameter, L.Con.MeasDec))
                font.pixelSize: Theme.fontSizeM
            }
            //: Maximum diameter with millimeter as unit.
            Text {
                text: qsTr("Max.: %L1mm").arg(L.LMath.roundToFixed(root.modelData.measurePoint.max.diameter, L.Con.MeasDec))
                font.pixelSize: Theme.fontSizeM
            }
        }
    }

    HoverHandler {
        id: hover
    }

    VCH.Tap {
        gesturePolicy: TapHandler.ReleaseWithinBounds

        onTapped: root.tapped(root.modelData.id)
    }
}
