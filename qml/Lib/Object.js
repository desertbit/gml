.pragma library

.import QtQuick as Quick

// copy deep copies all properties of src into dst.
// It can handle all native js types + Date.
// Args:
//  - src(object) : The source object to copy from.
//  - dst(object) : The destination object to copy to.
// Ret:
//  - Returns dst for convenience.
function copy(src, dst) {
    for (const i in src) {
        // Copy the javascript value.
        dst[i] = deepCopy(src[i])
    }
    return dst
}

// copyFrom deep copies all properties of dst from src.
// It can handle all native js types + Date.
// Missing properties in src are skipped.
// Args:
//  - dst(object) : The destination object to copy into.
//  - src(object) : The source object to copy from.
function copyFrom(dst, src) {
    for (const i in dst) {
        if (!src.hasOwnProperty(i)) {
            continue
        }

        // Copy the javascript value.
        dst[i] = deepCopy(src[i])
    }
}

// hasFunc returns true, if obj has the given function property.
// Args:
//  - o(object)        : The object to be checked.
//  - funcName(string) : The name of the function property on the object.
// Ret:
//  - bool
function hasFunc(o, func) {
    return o.hasOwnProperty(func) && typeof o[func] === "function"
}

// deepCopy is a helper that deep copies the given value.
// Args:
//  - src(any) : The value to copy. Allowed are all js types and QtObject.
// Ret:
//  - any
function deepCopy(v) {
    switch (typeof v) {
    case "undefined":
        return undefined

    case "object":
        if (v === null) {
            return null
        }
        if (v instanceof Date) {
            return new Date(v)
        }
        if (Array.isArray(v)) {
            return v.map(e => deepCopy(e))
        }

        // Copy the standard object.

        const isQtObject = v instanceof Quick.QtObject
        let o = {}
        for (const i in v) {
            // Ignore the default objectName property of QtObjects.
            if (isQtObject && i === "objectName") {
                continue
            }

            o[i] = deepCopy(v[i])
        }
        return o

    default:
        // Simply return basic types and functions.
        return v
    }
}

// deepEqual checks the given values for deep equality.
// Args:
//  - v1(any) : The first value to check.
//  - v2(any) : The second value to check.
// Ret:
//  - bool
function deepEqual(v1, v2) {
    const t1 = typeof v1
    const t2 = typeof v2

    if (t1 !== t2) {
        return false
    }

    switch (t1) {
    case "undefined":
        return t2 === undefined

    case "function":
        return true

    case "object":
        if (v1 === null) {
            return v2 === null
        }
        if (v2 === null) {
            return false
        }
        if (v1 instanceof Date) {
            return v2 instanceof Date && v1.getTime() === v2.getTime()
        }
        if (Array.isArray(v1)) {
            return Array.isArray(v2) && v1.length === v2.length && v1.every((e1, i) => deepEqual(e1, v2[i]))
        }

        // Check first whether the objects' properties already differ.
        const v1Keys = Object.keys(v1)
        const v2Keys = Object.keys(v2)
        if (v1Keys.length !== v2Keys.length || !v1Keys.every(k1 => v2Keys.includes(k1))) {
            return false
        }

        // Now compare each value of the objects.
        for (const k in v1) {
            if (!deepEqual(v1[k], v2[k])) {
                return false
            }
        }
        return true

    default:
        return v1 === v2
    }
}

// applyDiff compares every property of src against every property of dst.
// Every property is then checked for deep equality. Should a property not be deeply equal,
// the property in dst is replaced with a deep copy of the property of src.
//
// The main takeaway from this is, that after this function returns, src and dst are deeply
// equal with the minimum of copying necessary to achieve that.
//
// Args:
//  - src(object)   : The master object whose values will be applied to dst, if different.
//  - dst(QtObject) : The slave object whose values are overwritten, if different.
function applyDiff(src, dst) {
    for (const key in src) {
        const v = src[key]

        switch (typeof v) {
        case "undefined":
        case "function":
            continue

        case "object":
            if (v instanceof Date) {
                if (v.getTime() !== dst[key].getTime()) {
                    dst[key] = new Date(v)
                }
                continue
            }
            if (Array.isArray(v)) {
                // Check, if the arrays are deeply equal.
                // If not, we must create a deep copy for it.
                if (!deepEqual(v, dst[key])) {
                    dst[key] = v.map(e => deepCopy(e))
                }
                continue
            }

            // If the target is a QtObject, we must descend one level down.
            if (dst[key] instanceof Quick.QtObject) {
                applyDiff(v, dst[key])
                continue
            }

            // A standard javascript object.
            // If it is not deeply equal, we need to completely replace
            // it to trigger the property bindings.
            if (!deepEqual(v, dst[key])) {
                dst[key] = deepCopy(v)
            }

            continue

        default:
            // Simply assign basic types.
            // This will only trigger a property change signal, if the
            // values are not equal, which is what we want.
            dst[key] = src[key]
        }
    }
}
