.pragma library

// Converts a JS object to a QColor.
// Args:
//  - js(object) : Object containing properties "r", "g" and "b" for the corresponding channels.
// Ret:
//  - QColor
function jsRGBToQMLColor(js) {
    return Qt.rgba(js.r/255, js.g/255, js.b/255, 1)
}

// Converts a QColor to a JS object.
// Args:
//  - qc(QColor) : The QColor to convert.
// Ret:
//  - object
function qmlColorToJsRGB(qc) {
    return {
        R: Math.round(qc.r*255),
        G: Math.round(qc.g*255),
        B: Math.round(qc.b*255),
    }
}

// Returns a readable foreground color for the given background QColor.
// Args:
//  - qc(QColor) : The background color.
// Ret:
//  - string
function foregroundOfColor(qc) {
    // Based on https://stackoverflow.com/a/3943023/5341805
    // we calculate a value of the background color to check, if black
    // gives us better contrast and hence, readability.
    if ((qc.r*0.299)+(qc.g*0.587)+(qc.b*0.114) > (150/255)) {
        return "#000000"
    }
    return "#ffffff"
}

// Returns a random color, omitting very light and dark ones.
// Ret:
//  - QColor
function random() {
    // Limit channel values to prevent very light / dark colors.
    const max = 0.9
    const min = 0.4
    const diff = max - min

    return Qt.rgba(
        Math.random() * diff + min,
        Math.random() * diff + min,
        Math.random() * diff + min,
        1
    )
}
