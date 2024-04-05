Run {
    property string productName: ""
    // Contains Model.RunPause objects.
    property var pauses: []
    // Contains Model.Event objects.
    property var latestEvents: []
    // Contains Model.AggrEvent objects.
    property var aggrEvents: []
    // Contains { eventCode: count } objects.
    property var eventDistribution: ({})
    // Contains Model.AggrMeasurePoint objects.
    property var aggrMeasurePoints: []

    // If true, the user skipped the RunOverview page.
    property bool skippedRunOverview: false
}
