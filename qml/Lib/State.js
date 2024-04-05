.pragma library

const Initializing                  = 0x00
const Setup                         = 0x01
const Ready                         = 0x10
const Run                           = 0x20
const RunPaused                     = 0x21
const TrainProduct                  = 0x30
const TrainProductCameraSetup       = 0x31
const TrainProductCollecting        = 0x32
const TrainProductMeasuring         = 0x33
const TrainProductPreparingTraining = 0x34
const TrainProductTraining          = 0x35
const TrainProductConverting        = 0x36
const TrainProductDone              = 0x37
const ClassifyRun                   = 0x41
const Error                         = 0xA0

function isRun(state) {
    return (state & 0xF0) === Run
}

function isTrain(state) {
    return (state & 0xF0) === TrainProduct
}

const ErrCode = {
    NoError:              0x00,
    RunMaxEventsReached:  0x01,
    RunAbortedByShutdown: 0x02,
    Internal:             0xF0
}

function errCodeDebug(code) {
    switch (code) {
    case ErrCode.NoError:
        return "NoError"
    case ErrCode.RunMaxEventsReached:
        return "RunMaxEventsReached"
    case ErrCode.RunAbortedByShutdown:
        return "RunAbortedByShutdown"
    case ErrCode.Internal:
        return "Internal"
    default:
        return `UNKNOWN(${code})`
    }
}

// Formats the code as 0xF8, 0x01, ...
function fmtErrCode(code) {
    return `0x${code.toString(16).padStart(2, '0').toUpperCase()}`
}

function errTitle(code) {
    switch (code) {
    case ErrCode.RunMaxEventsReached:
        return qsTr("Batch failed")

    case ErrCode.RunAbortedByShutdown:
        return qsTr("Batch aborted")

    default:
        return qsTr("Internal error")
    }
}

function errSubTitle(code) {
    switch (code) {
    case ErrCode.RunMaxEventsReached:
    case ErrCode.RunAbortedByShutdown:
        return qsTr("There was an error during the execution of this batch.")

    default:
        return qsTr("Please contact the support with a screenshot of this error.")
    }
}

function errDescription(code, msg) {
    // Check, if it is a predefined error.
    switch (code) {
    case ErrCode.RunMaxEventsReached:
        msg = qsTr("The batch has been automatically closed, because it reached the maximum number of possible events.")
        break

    case ErrCode.RunAbortedByShutdown:
        msg = qsTr("The batch was interruped by a shutdown of nLine.")
    }

    return msg
}

function entityName(lastState) {
    if (isTrain(lastState)) {
        return qsTr("Product")
    }
    if (isRun(lastState)) {
        return qsTr("Batch")
    }
    return qsTr("Entity")
}

function name(ss) {
    switch (ss) {
    case Ready:
        return qsTr("Ready")
    case Setup:
        return qsTr("Setup required")
    case Initializing:
        return qsTr("Initializing")
    case Run:
        return qsTr("Batch active")
    case RunPaused:
        return qsTr("Batch paused")
    case TrainProduct:
        return qsTr("Product training") + " : " + qsTr("Standby")
    case TrainProductCameraSetup:
        return qsTr("Product training") + " : " + qsTr("Camera setup")
    case TrainProductCollecting:
        return qsTr("Product training") + " : " + qsTr("Collecting images")
    case TrainProductMeasuring:
        return qsTr("Product training") + " : " + qsTr("Calibrating measurement")
    case TrainProductPreparingTraining:
        return qsTr("Product training") + " : " + qsTr("Preparation")
    case TrainProductTraining:
        return qsTr("Product training") + " : " + qsTr("Training")
    case TrainProductConverting:
        return qsTr("Product training") + " : " + qsTr("Converting")
    case TrainProductDone:
        return qsTr("Product training") + " : " + qsTr("Done")
    case ClassifyRun:
        return qsTr("Classify batch")
    case Error:
        return qsTr("Error")
    default:
        return _missingTr("state.name", ss)
    }
}

function shortName(ss) {
    switch (ss) {
    case TrainProduct:
        return qsTr("Standby")
    case TrainProductCameraSetup:
        return qsTr("Camera setup")
    case TrainProductCollecting:
        return qsTr("Collecting images")
    case TrainProductMeasuring:
        return qsTr("Calibrating measurement")
    case TrainProductPreparingTraining:
        return qsTr("Preparation")
    case TrainProductTraining:
        return qsTr("Training")
    case TrainProductConverting:
        return qsTr("Converting")
    case TrainProductDone:
        return qsTr("Done")
    default:
        return name(ss)
    }
}

//###############//
//### Private ###//
//###############//

function _missingTr(name, s) {
    return `MISSING_TR(${name}:${s})`
}
