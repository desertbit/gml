.pragma library

.import Dispatcher as D

// View the PDF preview page of the report for the given run.
// Args:
//  - runID(int) : The id of the run.
function viewReport(runID) {
    D.Dispatcher.dispatch(_type(viewReport.name), { runID: runID })
}

// View the PDF preview page for the given resource.
// Args:
//  - resourceID(int) : The id of the resource.
function viewResource(resourceID) {
    D.Dispatcher.dispatch(_type(viewResource.name), { resourceID: resourceID })
}

//################//
//### Internal ###//
//################//

// Downloads the pdf document for the report of the run with the given id.
// Args:
//  - id(int)        : The id of the run to generate the pdf preview for
//  - locale(string) : The locale for the pdf
function downloadReport(id, locale) {
    D.Dispatcher.dispatch(_type(downloadReport.name), {
        id: id,
        locale: locale
    })
}

// Downloads the pdf document for the resource with the given id.
// Args:
//  - id(int)        : The id of the resource to download
//  - locale(string) : The locale of the resource
function downloadResource(id, locale) {
    D.Dispatcher.dispatch(_type(downloadResource.name), {
        id: id,
        locale: locale
    })
}

// Cleans the downloaded pdf resource from the local file system.
// Args:
//  - path(string) : The source path pointing to the pdf file
function cleanupFile(path) {
    D.Dispatcher.dispatch(_type(cleanupFile.name), { path: path })
}

//###############//
//### Private ###//
//###############//

// Returns the action type for the given function name of this script.
// Ret:
//  - string
function _type(funcName) {
    return "pdfPreview" + funcName.capitalize()
}
