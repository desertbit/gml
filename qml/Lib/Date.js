.pragma library

// 1 January, 1 AD (QML Calendar min default)
const Min = new Date(1, 0, 1)
// 25 October, 275759 AD (QML Calendar max default)
const Max = new Date(275759, 9, 25, 0, 0, 0, 0)
// The invalid date used to reset date properties.
// Use Date.valid() to check for invalid dates.
const Invalid = new Date('foobar')

// Static

// Constructs a new Date object from the given Go timestamp.
// If time is null, the Invalid date object is returned.
Date.fromGo = function(time) { return time === null ? Invalid : new Date(Date.parse(time)) }

// Instance

// formatDate is a convenience func that formats the date with the given locale to a string.
Date.prototype.formatDate = function(locale) { return this.toLocaleString(Qt.locale(locale), qsTr("MM/dd/yy")) }

// formatTime is a convenience func that formats the time with the given locale to a string.
Date.prototype.formatTime = function(locale) { return this.toLocaleString(Qt.locale(locale), qsTr("h:mm:ss AP")) }

// formatDateTime is a convenience func that formats the date and time with the given locale to a string.
Date.prototype.formatDateTime = function(locale) { return this.toLocaleString(Qt.locale(locale), qsTr("MM/dd/yy h:mm:ss AP")) }

// valid returns true, if the date is a valid date.
Date.prototype.valid = function() { return !isNaN(this) }

// after returns true, if this date instance comes after the other date instance.
Date.prototype.after = function(other) { return this.valid() && other.valid() && this.getTime() > other.getTime() }

// before returns true, if this date instance comes after the other date instance.
Date.prototype.before = function(other) { return this.valid() && other.valid() && this.getTime() < other.getTime() }

// differ compares the given dates and returns true, if they are equal.
// Equality is determined by comparing the year, month, date, hour and minute
// of both times with each other.
// If one, but not both, of the given dates is falsy, it returns true.
// If both dates are invalid or falsely, it returns false.
function differ(d1, d2) {
    if ((!d1 && !d2) || (!d1.valid() && !d2.valid())) {
        return false
    }

    return !d1 || !d2 ||
            d1.getFullYear() !== d2.getFullYear() ||
            d1.getMonth() !== d2.getMonth() ||
            d1.getDate() !== d2.getDate() ||
            d1.getHours() !== d2.getHours() ||
            d1.getMinutes() !== d2.getMinutes() ||
            d1.getSeconds() !== d2.getSeconds()
}

// Durations are in milliseconds.
const Second = 1000
const Minute = Second * 60
const Hour = Minute * 60
const Day = Hour * 24

// Returns a formatted string with a human-readable description of the given duration.
// Dur must be in milliseconds.
function formatDuration(dur) {
    const d = Math.floor(dur / Day)
    dur -= d * Day
    const h = Math.floor(dur / Hour)
    dur -= h * Hour
    const m = Math.floor(dur / Minute)
    dur -= m * Minute
    const s = Math.floor(dur / Second)
    dur -= s * Second
    const ms = dur

    let fmt = ""
    if (d > 0) {
        fmt += d > 1 ? qsTr("%L1 days").arg(d) : qsTr("%L1 day").arg(d)
    }
    if (h > 0) {
        //: Abbreviation for hour(s)
        fmt += (fmt !== "" ? " " : "") + qsTr("%L1h").arg(h)
    }
    if (m > 0) {
        //: Abbreviation for minute(s)
        fmt += (fmt !== "" ? " " : "") + qsTr("%L1min").arg(m)
    }
    if (s > 0) {
        //: Abbreviation for second(s)
        fmt += (fmt !== "" ? " " : "") + qsTr("%L1s").arg(s)
    }
    if (ms > 0) {
        //: Abbreviation for millisecond(s)
        fmt += (fmt !== "" ? " " : "") + qsTr("%L1ms").arg(ms)
    }
    return fmt
}
