.pragma library

.import Action as A
.import Lib as L

.import "../conv.js" as Conv

function viewFromProductDetail(state, data) {
    // Retrieve the run for the events.
    const run = state.productDetail.recentRuns.find(r => r.id === data.runID)

    state.eventOverview.skippedRunOverview = true
    state.eventOverview.skippedRunDetail = true
    state.eventOverview.skippedRunName = run.name

    _loadPageInit(state, data.productID, run, data.viewState)
}

//--------------------------------------------

function viewFromRunOverview(state, data) {
    // Retrieve the run for the events.
    const run = state.runOverview.page.find(r => r.id === data.runID)

    state.eventOverview.skippedRunDetail = true
    state.eventOverview.skippedRunName = run.name
    
    _loadPageInit(state, data.productID, run, data.viewState)
}

//--------------------------------------------

function viewFromRunDetail(state, data) {
    // The run detail page is shared between run and runRecent.
    // Check via the id, which one it is.
    const run = data.runID === state.runDetail.id ? state.runDetail : state.runRecent

    _loadPageInit(state, data.productID, run, data.viewState)
}

//--------------------------------------------

function viewFromRunRecentOverview(state, data) {
    // Retrieve the run for the events.
    const run = state.runRecentOverview.page.find(r => r.id === data.runID)

    state.eventOverview.skippedRunDetail = true
    state.eventOverview.skippedRunName = run.name

    _loadPageInit(state, data.productID, run, data.viewState)
}

//--------------------------------------------

function viewFromStatus(state, data) {
    const run = state.runActive

    state.eventOverview.skippedRunOverview = true
    state.eventOverview.skippedRunDetail = true
    state.eventOverview.skippedRunName = run.name

    _loadPageInit(state, run.productID, run, L.Con.EventOverviewState.List)
}

//--------------------------------------------

function setFilter(state, data) {
    // Remember which data changed, so we only reload affected views.
    const afterTSChanged = L.LDate.differ(state.eventOverview.filter.afterTS, data.afterTS)
    const beforeTSChanged = L.LDate.differ(state.eventOverview.filter.beforeTS, data.beforeTS)
    const eventCodesChanged = !L.Obj.deepEqual(state.eventOverview.filter.eventCodes, data.eventCodes)
    const anomalyClassIDsChanged = !L.Obj.deepEqual(state.eventOverview.filter.anomalyClassIDs, data.anomalyClassIDs)
    const timeIntervalChanged = state.eventOverview.filter.timeInterval !== data.timeInterval

    if (afterTSChanged || beforeTSChanged) {
        state.eventOverview.filter.afterTS = data.afterTS
        state.eventOverview.filter.beforeTS = data.beforeTS

        const from = data.afterTS.valid() ? data.afterTS : state.eventOverview.filter.minTS
        const to = data.beforeTS.valid() ? data.beforeTS : state.eventOverview.filter.maxTS

        // Update the time range and reset the time interval.
        const diffMs = to.getTime() - from.getTime()
        state.eventOverview.filter.timeRange = diffMs >= 0 ? Math.ceil(diffMs / 1000) : 0
        _resetTimeInterval(state)
    } else if (timeIntervalChanged) {
        state.eventOverview.filter.timeInterval = data.timeInterval
    }

    // Always update these filters.
    state.eventOverview.filter.eventCodes = data.eventCodes
    state.eventOverview.filter.anomalyClassIDs = data.anomalyClassIDs
    
    // Reload the data for all affected views.
    if (afterTSChanged || beforeTSChanged || eventCodesChanged || anomalyClassIDsChanged) {
        // Load the first page of the list.
        A.AEventOverview.loadListFirstPage()
    } 
    if (afterTSChanged || beforeTSChanged || eventCodesChanged || timeIntervalChanged) {
        _loadChart(state)
    }
    if (afterTSChanged || beforeTSChanged || eventCodesChanged) {
        _loadDistribution(state)
    }
    if (afterTSChanged || beforeTSChanged || eventCodesChanged || timeIntervalChanged) {
        _loadMeasurementChart(state)
    }
}

//--------------------------------------------

function setListLimit(state, data) {
    state.eventOverview.list.limit = data.limit

    // Load the first page of the list.
    A.AEventOverview.loadListFirstPage()
}

//--------------------------------------------

function loadListFirstPage(state, data) {
    // Reset the pagination cursor.
    state.eventOverview.list.cursor.after = ""
    state.eventOverview.list.cursor.before = ""

    // Issue the Api request.
    _loadList(state)
}

//--------------------------------------------

function loadListNextPage(state, data) {
    // Prepare the cursor to request the next page.
    state.eventOverview.list.cursor.before = ""

    // Issue the Api request.
    _loadList(state)
}

//--------------------------------------------

function loadListPrevPage(state, data) {
    // Prepare the cursor to request the next page.
    state.eventOverview.list.cursor.after = ""

    // Issue the Api request.
    _loadList(state)
}

//################//
//### Internal ###//
//################//

function loadListOk(state, data) {
    Conv.eventsFromGo(data.events)

    state.eventOverview.list.page = data.events
    state.eventOverview.list.totalCount = data.totalCount
    state.eventOverview.list.filteredCount = data.filteredCount
    L.Obj.copyFrom(state.eventOverview.list.cursor, data.cursor)
}

//--------------------------------------------

function loadChartOk(state, data) {
    Conv.aggrEventsFromGo(data.aggrEvents)

    state.eventOverview.chart.points = data.aggrEvents
}

//--------------------------------------------

function loadDistributionOk(state, data) {
    state.eventOverview.distribution.model = data.distribution
}

//--------------------------------------------

function loadMeasurementChartOk(state, data) {
    Conv.aggrMeasurePointsFromGo(data.points)

    state.eventOverview.measurement.points = data.points
}

//###############//
//### Private ###//
//###############//

// Sets up the initial eventOverview state.
function _loadPageInit(state, productID, run, viewState) {
    // Check, if the events of a previous run were displayed and if this run
    // is the same again. If it is not, we must reset the temporal filters.
    if (state.eventOverview.runID !== run.id) {
        state.eventOverview.filter.afterTS = L.LDate.Invalid
        state.eventOverview.filter.beforeTS = L.LDate.Invalid
    }

    state.eventOverview.productID = productID
    state.eventOverview.runID = run.id
    state.eventOverview.viewState = viewState

    // Load measurement values.
    state.eventOverview.measurement.enabled = run.enableMeasurement
    state.eventOverview.measurement.diameterNorm = run.diameterNorm
    state.eventOverview.measurement.diameterMin = run.diameterNorm - run.diameterLowerDeviation
    state.eventOverview.measurement.diameterMax = run.diameterNorm + run.diameterUpperDeviation

    // Set the minimum and maximum for the datetime filters.
    state.eventOverview.filter.minTS = run.created
    state.eventOverview.filter.maxTS = run.isFinished ? run.finished : new Date()

    // Build the time interval model and calculate the time range.
    const diffMs = state.eventOverview.filter.maxTS.getTime() - state.eventOverview.filter.minTS.getTime()
    state.eventOverview.filter.timeRange = Math.ceil(diffMs / 1000)
    _resetTimeInterval(state)

    // Ensure the anomaly classes are loaded.
    A.AAnomalyClass.load()

    // List is not loaded since we need to wait for its limit to be set.

    _loadChart(state)
    _loadDistribution(state)
    _loadMeasurementChart(state)
    A.ANavigation.pushPage(L.Con.Page.EventOverview)
}

function _loadList(state) {
    A.AEventOverview.loadList(
        state.eventOverview.runID,
        state.eventOverview.productID,
        state.eventOverview.filter.afterTS,
        state.eventOverview.filter.beforeTS,
        state.eventOverview.filter.eventCodes,
        state.eventOverview.filter.anomalyClassIDs,
        state.eventOverview.list.cursor,
        state.eventOverview.list.limit,
    )
}

function _loadChart(state) {
    A.AEventOverview.loadChart(
        state.eventOverview.runID,
        state.eventOverview.filter.afterTS,
        state.eventOverview.filter.beforeTS,
        state.eventOverview.filter.eventCodes,
        Math.ceil(state.eventOverview.filter.timeRange / state.eventOverview.filter.timeInterval)
    )
}

function _loadDistribution(state) {
    A.AEventOverview.loadDistribution(
        state.eventOverview.runID,
        state.eventOverview.filter.afterTS,
        state.eventOverview.filter.beforeTS,
        state.eventOverview.filter.eventCodes
    )
}

function _loadMeasurementChart(state) {
    A.AEventOverview.loadMeasurementChart(
        state.eventOverview.runID,
        state.eventOverview.filter.afterTS,
        state.eventOverview.filter.beforeTS,
        state.eventOverview.filter.eventCodes,
        Math.ceil(state.eventOverview.filter.timeRange / state.eventOverview.filter.timeInterval)
    )
}

function _resetTimeInterval(state) {
    state.eventOverview.filter.timeIntervals = L.TimeI.model(state.eventOverview.filter.timeRange)
    if (!state.eventOverview.filter.timeIntervals.empty()) {
        state.eventOverview.filter.timeInterval = state.eventOverview.filter.timeIntervals[0]
    }
}
