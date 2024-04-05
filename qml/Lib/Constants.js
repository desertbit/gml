.pragma library

// The number of events which will cause the export warning to appear when exceeding.
const WarnLargeEventExportNum = 500

// The maximum number of live events to have simultaneously for the active run.
const MaxActiveRunLiveEvents = 20

// The number of decimals for measurement representations.
const MeasDec = 2

// The recommended minimum sensitivity for custom presets.
const MinRecommendedSensitivity = 5
// The recommended maximum sensitivity for custom presets.
const MaxRecommendedSensitivity = 85

const AlarmCode = {
    Ok: 0,
    Err: 1
}

const AnomalyClass = {
    Unclassified: 0,
    NoError: 1
}

const CamPosition = {
    Unknown: 0,
    Top: 1,
    Front: 2,
    Back: 3
}

const Err = {
    Canceled:                 "canceled",
    ConnectFailed:            "connect failed",
    Closed:                   "closed",
    Initializing:             "initializing",

    CollectorRunning:         "collector running",
    CameraPositionNotSet:     "camera position not set",

    RunActive:                "run active",
    NoRunActive:              "no run active",
    RunNameAlreadyExists:     "run name already exists",
    RunNotFound:              "run not found",
    RunReportExporting:       "run report exporting",

    ProductTraining:          "product training",
    ProductNotFound:          "product not found",
    ProductNameAlreadyExists: "product name already exists",
    ProductUpdateRequired:    "product update required",
    ProductsLimitReached:     "products limit reached"
}

// Returns true, if the given error is a known error.
// Args:
//  - err(string) : The error message
// Ret:
//  - bool
function isKnownErr(err) {
    for (const k in Err) {
        if (Err[k] === err) {
            return true
        }
    }
    return false
}

// In which state the events overview page should be.
const EventOverviewState = {
    List: 0,
    Chart: 1,
    Distribution: 2,
    Measurement: 3
}

const Flip = {
    None: 0,
    X: 1,
    Y: 2,
    Both: 3
}

const NetworkMode = {
    DHCP: 0,
    Static: 1
}

const Notification = {
    DownloadNVision: 1,
    SaveNVisionToStorage: 2,
    DownloadResource: 3,
    SaveResourceToStorage: 4,
    DownloadRunExport: 5,
    SaveRunExportToStorage: 6,
    UpdateAvailable: 7,
    SetupExportData: 8
}

const Page = {
    AnomalyClassOverview: "anomalyClassOverview",
    CameraDetail: "cameraDetail",
    CameraFocus: "cameraFocus",
    ClassificationImageCreate: "classificationImageCreate",
    ClassificationImageDetail: "classificationImageDetail",
    ClassificationImageOverview: "classificationImageOverview",
    Dashboard: "dashboard",
    EventDetail: "eventDetail",
    EventOverview: "eventOverview",
    Help: "help",
    Status: "status",
    LoginConnect: "loginConnect",
    LoginDiscovery: "loginDiscovery",
    PDFPreview: "pdfPreview",
    ProductCreate: "productCreate",
    ProductDetail: "productDetail",
    ProductEdit: "productEdit",
    ProductOverview: "productOverview",
    ProductRetrain: "productRetrain",
    ProductTrainImages: "productTrainImages",
    RunCreate: "runCreate",
    RunDetail: "runDetail",
    RunExport: "runExport",
    RunOverview: "runOverview",
    RunRecentDetail: "runRecentDetail",
    RunRecentOverview: "runRecentOverview",
    Settings: "settings",
    Setup: "setup",
    SetupCameraMeasCalib: "setupCameraMeasCalib",
    SetupCameraMeasCalibGallery: "setupCameraMeasCalibGallery"
}

const Resource = {
    Manual: 1,
    QuickStartGuide: 2
}

const RunErr = {
    NoErr: 0,
    Internal: 1,
    CableNotFound: 2,
    CableAngleTooSteep: 3,
    CableTooNearToEdge: 4,
    CableTooSmall: 5,
    MeasureEdgeNotFound: 6,
    MeasureRegionOutOfBounds: 7,
}

const SensitivityPreset = {
    Custom: 0,
    Highest: 1,
    High: 2,
    Moderate: 3,
    Low: 4,
    Lowest: 5
}

const StreamType = {
    Raw: 1,
    Locator: 2,
    Defects: 3,
    DefectBoxes: 4,
    Measurement: 5
}
