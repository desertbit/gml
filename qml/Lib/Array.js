.pragma library

// Define a function on all arrays that conveniently returns the last element, or undefined.
Array.prototype.last = function() { return this.length > 0 ? this[this.length-1] : undefined }

// Define a function on all arrays that conveniently returns true, if the array is empty.
Array.prototype.empty = function() { return this.length === 0 }
