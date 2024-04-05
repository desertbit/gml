.pragma library

// roundToFixed rounds the given number to the specified number of digits
// and returns a string using the Number.toFixed builtin method.
function roundToFixed(number, digits) {
    const scale = 10**digits
    return ((Math.round(number * scale)) / scale).toFixed(digits)
}
