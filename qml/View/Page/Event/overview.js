.import Action as A
.import Lib as L

// Applies the current state in the UI controls as filter.
function updateFilter() {
    A.AEventOverview.setFilter(
        after.ts, 
        before.ts, 
        codeSelect.currentCodes, 
        classSelectActive.checked ? classSelect.currentClassIDs : null, 
        timeInterval.currentValue
    )
}

// Updates the filter with the data from the selected chart point.
// Args:
//  - codes(array)   : The event codes to filter by.
//  - afterTS(date)  : The from date to filter by.
//  - beforeTS(date) : The to date to filter by.
function applyChartPointFilter(codes, afterTS, beforeTS) {
    pageCtrl.page = 1
    after.ts = afterTS
    before.ts = beforeTS
    codeSelect.selectCodes(codes)
    classSelectActive.checked = false
    classSelect.selectClasses([])
    viewSelect.currentIndex = 0
    updateFilter()
}

// Resets the filter.
function resetFilter() {
    pageCtrl.page = 1
    after.ts = L.LDate.Invalid
    before.ts = L.LDate.Invalid
    codeSelect.selectAll()
    classSelect.selectClasses([])
    classSelectActive.checked = false
    updateFilter()
}
