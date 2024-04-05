import QtQuick
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl

// The BackgroundShadow can be assigned to background Items of Quick Controls.
// It will then provide a Material.elevation like shadow to it, with rounded corners.
// The parent component must have a radius property.
Rectangle {
    id: root

    color: parent.Material.backgroundColor
    radius: parent.Material.elevation > 0 ? parent.radius : 0

    layer.enabled: parent.enabled && parent.Material.elevation > 0
    layer.effect: ElevationEffect {
        elevation: root.parent.Material.elevation
    }
}
