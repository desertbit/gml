.pragma library

.import Dispatcher as D

// View the export run page to export the runs with the given ids.
// Args:
//  - ids(array) : The ids of the runs to export
function view(ids) {
    D.Dispatcher.dispatch(_type(view.name), { ids: ids })
}

// View the export run page to export the run with the given id.
// Must come from the run detail page.
// Args:
//  - id(int) : The id of the run to export
function viewFromRunDetail(id) {
    D.Dispatcher.dispatch(_type(viewFromRunDetail.name), { ids: [id] })
}

// Download the reports of the runs to a local file path.
// The path gets selected via the App middleware and will be added 
// to the action data on the fly.
// Args:
//  - ids(array)     : The ids of the runs to export
//  - locale(string) : The locale of the report
//  - html(bool)     : If true, each report contains the HTML format
//  - pdf(bool)      : If true, each report contains the PDF format
//  - csv(bool)      : If true, each report contains the CSV format
function download(ids, locale, html, pdf, csv) {
    D.Dispatcher.dispatch(_type(download.name), {
        ids: ids,
        locale: locale,
        html: html,
        pdf: pdf,
        csv: csv
    })
}

// Saves the reports of the runs to the storage device.
// Args:
//  - ids(array)              : The ids of the runs to export
//  - locale(string)          : The locale of the report
//  - storageDeviceID(string) : The id of the storage device
//  - html(bool)              : If true, each report contains the HTML format
//  - pdf(bool)               : If true, each report contains the PDF format
//  - csv(bool)               : If true, each report contains the CSV format
function saveToStorage(ids, locale, storageDeviceID, html, pdf, csv) {
    D.Dispatcher.dispatch(_type(saveToStorage.name), {
        ids: ids,
        locale: locale,
        storageDeviceID: storageDeviceID,
        html: html,
        pdf: pdf,
        csv: csv
    })
}

//################//
//### Internal ###//
//################//

// Loads the runs that should be exported.
// Args:
//  - ids(array) : The ids of the runs to export
function loadRuns(ids) {
    D.Dispatcher.dispatch(_type(loadRuns.name), { ids: ids })
}

//###############//
//### Private ###//
//###############//

// Returns the action type for the given function name of this script.
// Ret:
//  - string
function _type(funcName) {
    return "runExport" + funcName.capitalize()
}

