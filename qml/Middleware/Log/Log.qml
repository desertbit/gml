import QtQuick

import Lib as L

import "../Base"

// The Log middleware simply logs every action type and data object that passes through it.
Base {
    // If true, we log the data of most actions in full detail.
    readonly property bool verbose: true
    // If true, we log the data of every actions in full detail.
    readonly property bool debug: false

    onDispatched: function(type, data) {
        if (type === "SubscribeStateUpdate") {
            if (debug) {
                action(type, data)
            } else {
                console.log(`Action: "${type}" -- state: "${L.State.name(data.state)}"`)
            }
        } else if (((type.endsWith("Update") || type === "notificationUpdateProgress") && !debug) || (!verbose && !debug)) {
            // Only print the type and indicate, if data is sent along.
            console.log(`Action: "${type}" -- Data: {${Object.keys(data).length > 0 ? "..." : ""}}`)
        } else {
            // Log the action completely.
            action(type, data, !debug)
        }

        // Call the next middleware/store.
        next(type, data)
    }

    // action logs the given action type with its data to console.log.
    // Args:
    //  - type(string)      : The action type
    //  - data(object|null) : The action data
    //  - abbreviateArrays  : when true, only the first element of arrays is printed
    function action(type, data=null, abbreviateArrays=false) {
        let parts = [`Action: "${type}"`]
        if (data !== null) {
            parts.push(`\nData: `)
            parts = parts.concat(_stringify(data, 1, abbreviateArrays))
        }
        console.log(parts.join(""))
    }

    // _stringify creates a human-readable string representation for the given object.
    // Args:
    //  - data(any)        : object to be stringified
    //  - indentLevel(int) : the level of indentation
    //  - abbreviateArrays : when true, only the first element of arrays is printed
    // Returns:
    //  - Array containing the parts of the string.
    function _stringify(data, indentLevel=1, abbreviateArrays=false) {
        const _indent = "    "

        let result = []
        const dt = typeof data

        switch (dt) {
        case "function":
            result.push(`function(<numArgs=${data.length}>)`)
            break
        case "undefined":
            result.push(`undefined`)
            break
        case "object":
            if (Array.isArray(data)) {
                result.push("[")
                for (let i = 0; i < data.length; ++i) {
                    result = result.concat(_stringify(data[i], indentLevel, abbreviateArrays))

                    if (i < data.length-1) {
                        result.push(", ")
                    }

                    // Abort after the first iteration, if we want to abbreviate.
                    if (abbreviateArrays) {
                        if (data.length > 1) {
                            // Add an ellipsis that indicates the abbreviation.
                            result.push("...")
                        }

                        break
                    }
                }
                result.push(`] (len=${data.length})`)
            } else if (data instanceof Date) {
                result.push(`${data.toString()} (Date)`)
            } else if (data === null) {
                result.push("null")
            } else {
                const keys = Object.keys(data)
                if (keys.length === 0) {
                    result.push("{}")
                    break
                }

                result.push("{\n")
                for (const k of keys) {
                    result.push(_indent.repeat(indentLevel))
                    result.push(`${k}: `)
                    result = result.concat(_stringify(data[k], indentLevel+1, abbreviateArrays))
                    result.push("\n")
                }
                result.push(_indent.repeat(indentLevel-1))
                result.push("}")
            }
            break

        default:
            // Basic type.
            result.push(dt === "string" ? `"${data}"` : data)
            result.push(` (${dt})`)
            break
        }

        return result
    }

}
