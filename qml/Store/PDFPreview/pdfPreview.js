.pragma library

.import Action as A
.import Lib as L

function viewReport(state, data) {
    state.pdfPreview.runID = data.runID

    A.ANavigation.pushPage(L.Con.Page.PDFPreview, {})
    A.APDFPreview.downloadReport(data.runID, state.locale)
}

//--------------------------------------------

function viewResource(state, data) {
    state.pdfPreview.resourceID = data.resourceID

    A.ANavigation.pushPage(L.Con.Page.PDFPreview, {})
    A.APDFPreview.downloadResource(data.resourceID, state.locale)
}

//################//
//### Internal ###//
//################//

function downloadReport(state, data) {
    state.pdfPreview.callID = data.callID
}

function downloadReportUpdate(state, data) {
    state.pdfPreview.progress = data.progress
}

function downloadReportOk(state, data) {
    state.pdfPreview.source = data.source
    state.pdfPreview.numPages = data.numPages
}

function downloadReportDone(state, data) {
    state.pdfPreview.callID = 0
    state.pdfPreview.progress = 0
}

//--------------------------------------------

function downloadResource(state, data) {
    state.pdfPreview.callID = data.callID
}

function downloadResourceUpdate(state, data) {
    state.pdfPreview.progress = data.progress
}

function downloadResourceOk(state, data) {
    state.pdfPreview.source = data.source
    state.pdfPreview.numPages = data.numPages
}

function downloadResourceDone(state, data) {
    state.pdfPreview.callID = 0
    state.pdfPreview.progress = 0
}


