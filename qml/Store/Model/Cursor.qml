import QtQuick

QtObject {
    property string after: ""
    property string before: ""

    // Called by JSON.stringify().
    function toJSON() {
        return {
            after: after,
            before: before
        }
    }
}
