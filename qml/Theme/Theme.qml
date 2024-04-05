pragma Singleton

import QtQuick
import QtQuick.Controls.Material

QtObject {
    //###
    //### Sizes and Spacings
    //###

    readonly property real fontSizeXXXL: 32
    readonly property real fontSizeXXL:  28
    readonly property real fontSizeXL:   24
    readonly property real fontSizeL:    20
    readonly property real fontSizeM:    16
    readonly property real fontSizeS:    12
    readonly property real fontSizeXS:   10

    readonly property real spacingXXL:  88
    readonly property real spacingXL:   44
    readonly property real spacingL:    32
    readonly property real spacingM:    22
    readonly property real spacingS:    16
    readonly property real spacingXS:   10
    readonly property real spacingXXS:  6
    readonly property real spacingXXXS: 4

    readonly property real iconSizeXXL: 44
    readonly property real iconSizeXL:  36
    readonly property real iconSizeL:   32
    readonly property real iconSizeM:   28
    readonly property real iconSizeS:   24
    readonly property real iconSizeXS:  20
    readonly property real iconSizeXXS: 16

    readonly property real toolbarHeight: 58

    //###
    //### Colors
    //###

    readonly property real  theme:                Material.Light
    readonly property color colorPrimary:         "#2B323E" // nLine dark blue background
    readonly property color colorAccent:          "#EB393B" // nLine red accent
    readonly property color colorForeground:      "black" // Main font color.
    readonly property color colorForegroundTier2: Material.color(Material.Grey, Material.Shade800) // Tier 2 font color.
    readonly property color colorForegroundTier3: Material.color(Material.Grey, Material.Shade600) // Tier 3 font color.
    readonly property color colorAppBackground:   "#F6F6F6"
    readonly property color colorBackground:      "white"
    readonly property color colorBackgroundTier2: "#E9E9E9"
    readonly property color colorOnPrimary:       "white" // Color to use on primary color.
    readonly property color colorOnAccent:        "white" // Color to use on accent color.

    readonly property color colorProduct:           Material.color(Material.Blue, Material.Shade700)
    readonly property color colorProductTier2:      Material.color(Material.Blue, Material.Shade400)
    readonly property color colorOnProduct:         "white"
    readonly property color colorSettings:          Material.color(Material.Grey, Material.Shade500)
    readonly property color colorOnSettings:        "white"
    readonly property color colorRun:               Material.color(Material.DeepPurple, Material.Shade600)
    readonly property color colorRunTier2:          Material.color(Material.DeepPurple, Material.Shade400)
    readonly property color colorOnRun:             "white"
    readonly property color colorExport:            Material.color(Material.LightGreen, Material.Shade500)
    readonly property color colorOnExport:          "white"
    readonly property color colorAnomalyClass:      Material.color(Material.Pink, Material.Shade300)
    readonly property color colorAnomalyClassTier2: Material.color(Material.Pink, Material.Shade600)
    readonly property color colorOnAnomalyClass:    "white"
    readonly property color colorClassifyRun:       Material.color(Material.Teal, Material.Shade300)
    readonly property color colorOnClassifyRun:     "white"
    readonly property color colorSetup:             Material.color(Material.Orange, Material.Shade500)
    readonly property color colorOnSetup:           "white"

    readonly property color colorSeparator: "lightGrey"

    readonly property color colorEventError: "orangered"
    readonly property color colorEventDefect: "mediumturquoise"
    readonly property color colorEventMeasureDrift: "mediumslateblue"

    readonly property color listDelegateBackgroundHighlight: "#D2E0F9"
    readonly property color listDelegateBackground1: colorBackground
    readonly property color listDelegateBackground2: colorBackgroundTier2

    readonly property color success: "#16AB39"
    readonly property color warning: "#EDF41F"
    readonly property color error:  "#B92D00"

    readonly property color halfTransparentBlack: "#66000000"
    readonly property color transparentBlack:     "#A5000000"
}
