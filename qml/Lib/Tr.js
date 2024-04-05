.pragma library

.import "Constants.js" as Con

// Translations file.

function anomalyClass(id, name) {
    if (id === Con.AnomalyClass.Unclassified) {
        return qsTr("Unclassified")
    }
    if (id === Con.AnomalyClass.NoError) {
        return qsTr("No Error")
    }
    // All other classes are custom user strings, no tr needed.
    return name
}

function camPosition(pos) {
    switch (pos) {
    case Con.CamPosition.Unknown: return ""
    case Con.CamPosition.Top:     return qsTr("Top")
    case Con.CamPosition.Front:   return qsTr("Front")
    case Con.CamPosition.Back:    return qsTr("Back")
    default:                       return _missingTr("position", pos)
    }
}

function dialogButtonText(t) {
    switch (t) {
    case "OK":                   return qsTr("Ok")
    case "Open":                 return qsTr("Open")
    case "Save":                 return qsTr("Save")
    case "Cancel":               return qsTr("Cancel")
    case "Close":                return qsTr("Close")
    case "Close without Saving": return qsTr("Discard")
    case "Discard":              return qsTr("Discard") // Same as "Close without Saving" but for Windows.
    case "Apply":                return qsTr("Apply")
    case "Reset":                return qsTr("Reset")
    case "RestoreDefaults":      return qsTr("Restore defaults")
    case "Help":                 return qsTr("Help")
    case "SaveAll":              return qsTr("Save all")
    case "Yes":                  return qsTr("Yes")
    case "YesToAll":             return qsTr("Yes to all")
    case "No":                   return qsTr("No")
    case "NoToAll":              return qsTr("No to all")
    case "Abort":                return qsTr("Abort")
    case "Retry":                return qsTr("Retry")
    case "Ignore":               return qsTr("Ignore")
    default:                     return _missingTr("dialogButtonText", t)
    }
}

function err(e) {
    switch (e) {
    case Con.Err.CameraPositionNotSet:
        return qsTr("The position of the cameras must be set")
    case Con.Err.Closed:
        return qsTr("Closed")

    case Con.Err.CollectorRunning:
        return qsTr("The collector is running")

    case Con.Err.RunActive:
        return qsTr("A batch is active")
    case Con.Err.NoRunActive:
        return qsTr("No batch is active")
    case Con.Err.RunNameAlreadyExists:
        return qsTr("A batch with this name already exists")
    case Con.Err.RunNotFound:
        return qsTr("The batch could not be found")
    case Con.Err.RunReportExporting:
        return qsTr("A batch is currently being exported. If you have just canceled an export, please retry again.")

    case Con.Err.ProductTraining:
        return qsTr("A product is being trained")
    case Con.Err.ProductNotFound:
        return qsTr("The product could not be found")
    case Con.Err.ProductNameAlreadyExists:
        return qsTr("A product with this name already exists")
    case Con.Err.ProductUpdateRequired:
        return qsTr("The product must be retrained first")
    case Con.Err.ProductsLimitReached:
        return qsTr("You have reached the maximum number of products this nLine device can store.")

    default:
        //: The message for an unexpected error, the argument is the error from the server.
        return qsTr("%1 (internal error)").arg(e)
    }
}

function eventOverviewState(e) {
    switch (e) {
    case Con.EventOverviewState.List:         return qsTr("List")
    case Con.EventOverviewState.Chart:        return qsTr("Graph")
    case Con.EventOverviewState.Distribution: return qsTr("Distribution")
    case Con.EventOverviewState.Measurement:  return qsTr("Measurement")
    default:                                  return _missingTr("eventOverviewState", e)
    }
}

function flip(f) {
    switch (f) {
    case Con.Flip.None: return qsTr("Standard")
    case Con.Flip.X:    return qsTr("Horizontal")
    case Con.Flip.Y:    return qsTr("Vertical")
    case Con.Flip.Both: return qsTr("Horizontal and Vertical")
    default:             return _missingTr("flip", f)
    }
}

function locale(l) {
    const lang = l.substr(0, 2)
    switch (lang) {
    case "en": return qsTr("English")
    case "de": return qsTr("German")
    default:   return _missingTr("locale", lang)
    }
}

function networkMode(n) {
    switch (n) {
    case Con.NetworkMode.DHCP:
        //: Abbreviation for Dynamic Host Configuration Protocol.
        return qsTr("DHCP")
    case Con.NetworkMode.Static:
        //: As in a static network configuration.
        return qsTr("Static")
    default:
        return _missingTr("networkMode", n)
    }
}

function notification(n) {
    switch (n) {
    case Con.Notification.DownloadNVision:
        return qsTr("Download nVision")
    case Con.Notification.SaveNVisionToStorage:
        return qsTr("Save nVision to storage")
    case Con.Notification.DownloadResource:
        return qsTr("Download document")
    case Con.Notification.SaveResourceToStorage:
        return qsTr("Save document to storage")
    case Con.Notification.DownloadRunExport:
        //: The report is the export of a batch.
        return qsTr("Download report")
    case Con.Notification.SaveRunExportToStorage:
        //: The report is the export of a batch.
        return qsTr("Save report to storage")
    case Con.Notification.SetupExportData:
        return qsTr("Export setup data")
    default:
        return _missingTr("notification", n)
    }
}

function resource(r) {
    switch (r) {
    case Con.Resource.Manual:
        return qsTr("Manual")
    case Con.Resource.QuickStartGuide:
        return qsTr("Quickstart guide")
    default:
        return _missingTr("resource", r)
    }
}

function runErr(r) {
    switch (r) {
    case Con.RunErr.NoErr:
        return ""
    case Con.RunErr.Internal:
        return qsTr("Internal server error")
    case Con.RunErr.CableNotFound:
        return qsTr("Product not found")
    case Con.RunErr.CableAngleTooSteep:
        //: Normally, the product is horizontal.
        return qsTr("Product angle too steep")
    case Con.RunErr.CableTooNearToEdge:
        //: The edge of the camera field of view.
        return qsTr("Product too near to edge")
    case Con.RunErr.CableTooSmall:
        return qsTr("Product too small")
    case Con.RunErr.MeasureEdgeNotFound:
        return qsTr("Measurement edge not found")
    case Con.RunErr.MeasureRegionOutOfBounds:
        //: When the region at the edge of the product exceeds the image bounds.
        return qsTr("Measurement region out of bounds")
    default:
        return _missingTr("runErr", r)
    }
}


function sensitivityPreset(s) {
    switch (s) {
    case Con.SensitivityPreset.Custom:
        return qsTr("Custom")
    case Con.SensitivityPreset.Highest:
        return qsTr("Highest")
    case Con.SensitivityPreset.High:
        return qsTr("High")
    case Con.SensitivityPreset.Moderate:
        return qsTr("Moderate")
    case Con.SensitivityPreset.Low:
        return qsTr("Low")
    case Con.SensitivityPreset.Lowest:
        return qsTr("Lowest")
    default:
        return _missingTr("sensitivityPreset", s)
    }
}

function streamType(t) {
    switch (t) {
    case Con.StreamType.Raw:
        //: As in raw camera footage.
        return qsTr("Raw")
    case Con.StreamType.Locator:
        //: As in camera footage showing located product.
        return qsTr("Locator")
    case Con.StreamType.Defects:
        //: As in camera footage showing detected defects.
        return qsTr("Defects")
    case Con.StreamType.DefectBoxes:
        //: As in camera footage showing detected defect boxes.
        return qsTr("Defect boxes")
    case Con.StreamType.Measurement:
        return qsTr("Measurement")
    default:
        return _missingTr("streamType", t)
    }
}

//###############//
//### Private ###//
//###############//

function _missingTr(name, s) {
    return `MISSING_TR(${name}:${s})`
}
