.pragma library

.import Theme as T

const Code = {
    Error: 0,
    Defect: 1,
    MeasureDrift: 2
}

const ErrCode = {
    CableNotFound: 100,
    CableAngleTooSteep: 101,
    CableTooNearToEdge: 102,
    CableTooSmall: 103,
    MeasureEdgeNotFound: 300
}

// All event codes in a specific order.
const Codes = [Code.Defect, Code.MeasureDrift, Code.Error]

// Iterates all available event codes.
function forEachCode(f) {
    for (const key in Code) {
        f(Code[key])
    }
}

// Returns a human-readable description of the event code.
// Args:
//  - code(enum) : The event code.
// Ret:
//  - string
function codeName(code) {
    switch (code) {
    case Code.Error:
        return qsTr("Detection issue")
    case Code.Defect:
        return qsTr("Defect")
    case Code.MeasureDrift:
        return qsTr("Measuring error")
    default:
        return "UNKNOWN"
    }
}

// Returns the color for the event code.
// Args:
//  - code(enum) : The event code.
// Ret:
//  - color
function codeColor(code) {
    switch (code) {
    case Code.Error:
        return T.Theme.colorEventError
    case Code.Defect:
        return T.Theme.colorEventDefect
    case Code.MeasureDrift:
        return T.Theme.colorEventMeasureDrift
    default:
        return "black"
    }
}

// Returns a human-readable description of the event error code.
// Args:
//  - code(enum) : The event code.
// Ret:
//  - string
function errCodeName(code) {
    switch (code) {
    case ErrCode.CableNotFound:
        return qsTr("Product not found")
    case ErrCode.CableAngleTooSteep:
        //: Normally, the product is horizontal.
        return qsTr("Product angle too steep")
    case ErrCode.CableTooNearToEdge:
        //: The edge of the camera field of view.
        return qsTr("Product too near to edge")
    case ErrCode.CableTooSmall:
        return qsTr("Product too small")
    case ErrCode.MeasureEdgeNotFound:
        //: The edge of the product used for measurement could not be found.
        return qsTr("Measurement edge not found")
    default:
        return "UNKNOWN"
    }
}

// Returns the color for the event error code.
// Args:
//  - code(enum) : The event code.
// Ret:
//  - string
/*function codeColor(code) {
    switch (code) {
    case Code.Defect:
        return "mediumturquoise"
    case Code.MeasureDrift:
        return "mediumslateblue"
    case Code.ErrCableNotFound:
        return "orange"
    case Code.ErrCableAngleTooSteep:
        return "orangered"
    case Code.ErrCableTooNearToEdge:
        return "palevioletred"
    case Code.ErrCableTooSmall:
        return "peru"
    case Code.ErrMeasureEdgeNotFound:
        return "royalblue"
    default:
        return "black"
    }
}*/
