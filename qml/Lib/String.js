.pragma library

// Define a function on all strings that returns the string with its first letter converted to uppercase.
String.prototype.capitalize = function() { return this.charAt(0).toUpperCase() + this.slice(1) }

// Define a function on all strings that returns the string with its first letter converted to lowercase.
String.prototype.lowercase = function() { return this.charAt(0).toLowerCase() + this.slice(1) }
