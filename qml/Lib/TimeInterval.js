.pragma library

// The minimum number of aggregations we want to have.
const minAggregations = 4
// The maximum number of aggregations we want to allow.
const maxAggregations = 200

// The possible options that are available.
// All values are in seconds.
const possibleOptions = [1, 5, 15, 30, 60, 60*5, 60*15, 60*60, 60*60*12, 60*60*24]

// Builds the time interval model for the given time range.
// The idea is to split a given range in seconds into intervals of the same size.
//
// The calculation simply aims to provide a good balance of how much data
// the user can see at once and if the graph still stays reasonably readable.
// Args:
//  - timeRange(int) : The number of seconds of the total time range.
// Ret:
//  - array of possible intervals represented as integers(seconds).
function model(timeRange) {
    if (timeRange <= 0) {
        return []
    }

    const model = []
    for (const opt of possibleOptions) {
        const numAggregations = timeRange / opt
        if (numAggregations > maxAggregations || numAggregations < minAggregations) {
            continue
        }

        model.push(opt)
    }
    return model
}
