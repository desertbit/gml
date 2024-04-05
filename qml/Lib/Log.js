.pragma library

// error logs the failure of an operation with the given msg to console.error.
// Args:
//  - op(string)  : title of the operation
//  - msg(string) : message of the error
function error(op, msg) {
    console.error(`${op}: ${msg}`)
}
