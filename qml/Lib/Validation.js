.pragma library

const anomalyClassNameMinLen = 1
const anomalyClassNameMaxLen = 48
const ProductNameMinLen = 1
const ProductNameMaxLen = 32
const RunNameMinLen = 1
const RunNameMaxLen = 32

// Private member, but already declared here.
// Otherwise, a warning "qt.qml.compiler: :24:30 Variable "_result" is used before its declaration at 116:7." gets printed.
const _result = {
    Ok:            0x00,
    InvalidLength: 0x01,
    NonAscii:      0x02,
    SpecialName:   0x03,
    SpecialSymbol: 0x04,
    AlreadyExists: 0x05
}

// anomalyClassName validates the given name according to our validation rules for anomaly class names.
// It also checks, if the given name is unique against the provided anomaly classes.
// Args:
//  - name(string)          : The name to check.
//  - anomalyClasses(array) : The anomalyClasses which reserve some names already.
//  - allowEmpty(bool) : If true, empty names are allowed.
// Ret:
//  - string (Empty if valid)
function anomalyClassName(name, anomalyClasses=[], allowEmpty=false) {
    if (name.length < (allowEmpty ? 0 : anomalyClassNameMinLen) || name.length > anomalyClassNameMaxLen) {
        return qsTr("Must be %L1 to %L2 chars long").arg(anomalyClassNameMinLen).arg(anomalyClassNameMaxLen)
    }
    // We must ignore the special "unclassified" and "no error" classes.
    if (anomalyClasses.some(ac => ac.id !== 0 && ac.id !== 1 && ac.name === name)) {
        return resultMessage(_result.AlreadyExists)
    }
    return ""
}

// productName validates the given name according to our validation rules for product names.
// It also checks, if the given product name is unique against the provided products.
// Args:
//  - name(string)     : The name to check.
//  - products(array)  : The products which reserve some names already.
//  - allowEmpty(bool) : If true, empty names are allowed.
// Ret:
//  - string (Empty if valid)
function productName(name, products=[], allowEmpty=false) {
    const res = _name(name, allowEmpty ? 0 : ProductNameMinLen, ProductNameMaxLen)
    if (res !== _result.Ok) {
        if (res === _result.InvalidLength) {
            return qsTr("Must be %L1 to %L2 chars long").arg(ProductNameMinLen).arg(ProductNameMaxLen)
        }
        return resultMessage(res)
    }
    if (products.some(p => p.name === name)) {
        return resultMessage(_result.AlreadyExists)
    }
    return ""
}

// runName validates the given name according to our validation rules for run names.
// Args:
//  - name(string) : The name to check.
//  - allowEmpty(bool) : If true, empty names are allowed.
// Ret:
//  - string (Empty if valid)
function runName(name, allowEmpty=false) {
    const res = _name(name, allowEmpty ? 0 : RunNameMinLen, RunNameMaxLen)
    if (res !== _result.Ok) {
        if (res === _result.InvalidLength) {
            return qsTr("Must be %L1 to %L2 chars long").arg(RunNameMinLen).arg(RunNameMaxLen)
        }
        return resultMessage(res)
    }
    return ""
}

// measurement validates the given measurement settings.
// Args:
//  - enabled(bool) : Whether the measurement is active.
//  - norm(float)   : The target diameter value.
//  - upper(float)  : The upper deviation value.
//  - lower(float)  : The lower deviation value.
//  - width(float)  : The width of the measurement.
// Ret:
//  - bool
function measurement(enabled, norm, upper, lower, width) {
    // All diameter values must at least be valid numbers, at all times.
    if ([norm, upper, lower, width].some(n => Number.isNaN(n))) {
        return false
    }

    // If not enabled, the remaining values do not matter.
    if (!enabled) {
        return true
    }

    // Lower boundary may not decrease the target value to less than or equal to 0.
    return norm > 0 && upper >= 0 && lower >= 0 && lower < norm && width >= 0
}

//###############//
//### Private ###//
//###############//

const _namingRestrictions = {
    symbols: [
        '<', '>',
        ':', ';',
        '"', '\'', '`',
        '\\', '/', '|',
        '?', '*',
    ],

    // File name restrictions.
    names: [
        "CON", "CONIN$", "CONOUT$", "PRN", "AUX", "NUL",
        "COM0", "COM1", "COM2", "COM3", "COM4", "COM5", "COM6", "COM7", "COM8", "COM9",
        "LPT0", "LPT1", "LPT2", "LPT3", "LPT4", "LPT5", "LPT6", "LPT7", "LPT8", "LPT9",
    ]
}

const _regexMatchingDots = new RegExp("[\.]*")
const _regexMatchingBasicAscii = new RegExp("[^\x20-\x7E]")

// name checks the given value according to our naming restrictions
// and the given min and max length.
// Args:
//  - value(string) : The value to validate
//  - minLen(int)   : The minimum required length.
//  - maxLen(int)   : The maximum allowed length.
// Ret:
//  - result(enum)
function _name(value, minLen=0, maxLen=0) {
    // Check length first.
    if (value.length < minLen || (maxLen > 0 && value.length > maxLen)) {
        return _result.InvalidLength
    }

    // Check if the given value contains only basic ASCII chars.
    // https://en.wikipedia.org/wiki/ASCII#Printable_characters
    if (_regexMatchingBasicAscii.test(value)) {
        return _result.NonAscii
    }

    // Check for restricted names.
    value = value.toUpperCase()
    if (_namingRestrictions.names.some(n => n === value)) {
        return _result.SpecialName
    }

    // Check for restricted symbols.
    if (_namingRestrictions.symbols.some(s => value.includes(s))) {
        return _result.SpecialSymbol
    }

    // One and two dots are system reserved.
    // A file name only consisting of dots (any amount) is also not allowed on Windows.
    if (value !== "" && value.replace(_regexMatchingDots, "") === "") {
        return _result.SpecialName
    }

    return _result.Ok
}

function resultMessage(res) {
    switch (res) {
    case _result.InvalidLength:
        return qsTr("Invalid length")
    case _result.NonAscii:
        return qsTr("Contains non-ASCII characters")
    case _result.SpecialName:
        return qsTr("Is a system reserved name")
    case _result.SpecialSymbol:
        return qsTr("Contains an invalid symbol")
    case _result.AlreadyExists:
        return qsTr("Name already exists")
    default:
        return "UNKNOWN RESULT MESSAGE"
    }
}
