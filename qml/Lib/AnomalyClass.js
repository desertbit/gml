.pragma library

const Class = {
    Unclassified: 0,
    NoError: 1
}

function name(id) {
    if (id === Class.Unclassified) {
        return qsTr("Unclassified")
    }
    if (id === Class.NoError) {
        return qsTr("No Error")
    }
    return ""
}
