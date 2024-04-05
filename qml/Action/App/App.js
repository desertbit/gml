.pragma library

.import Dispatcher as D

// The nVision application started and the runtime options have been
// parsed on the Go side. Now load them into the QML state.
function loadRuntimeOptions() {
    D.Dispatcher.dispatch(_type(loadRuntimeOptions.name), {})
}

// Loads the local nVision application settings.
function loadSettings() {
    D.Dispatcher.dispatch(_type(loadSettings.name), {})
}

// User wants to quit nVision application.
function quit() {
    D.Dispatcher.dispatch(_type(quit.name), {})
}

// A user wants to switch the locale of the application.
// Args:
//  - locale(string) : The new locale to be set.
function switchLocale(locale) {
    D.Dispatcher.dispatch(_type(switchLocale.name), { locale: locale })
}

// Sets the options of nVision.
// Args:
//  - debugMode(bool)      :
function setOptions(debugMode) {
    D.Dispatcher.dispatch(_type(setOptions.name), {
        debugMode: debugMode
    })
}

// Shows the advanced options of nVision.
function showAdvancedOptions() {
    D.Dispatcher.dispatch(_type(showAdvancedOptions.name), {})
}

// Sets the advanced options of nVision.
// Args:
//  - fullscreenMode(bool)      :
//  - withVirtualKeyboard(bool) :
//  - withStorageDevices(bool)  :
//  - devMode(bool)             :
function setAdvancedOptions(fullscreenMode, withVirtualKeyboard, withStorageDevices, devMode) {
    D.Dispatcher.dispatch(_type(setAdvancedOptions.name), {
        fullscreenMode: fullscreenMode,
        withVirtualKeyboard: withVirtualKeyboard,
        withStorageDevices: withStorageDevices,
        devMode: devMode
    })
}

// Hides the advanced options of nVision.
function hideAdvancedOptions() {
    D.Dispatcher.dispatch(_type(hideAdvancedOptions.name), {})
}

//################//
//### Internal ###//
//################//

// Open the busy dialog with the given data, which shows a busy spinner
// with the given title and text inside a dialog.
// The dialog offers the user the option to cancel, if the given
// callID is > 0.
// Args:
//  - title(string) : The title of the dialog
//  - text(string)  : The text shown below the busy spinner.
//  - callID(int)   : The callID to cancel the operation.
function showBusyDialog(title, text, callID=0) {
    D.Dispatcher.dispatch(_type(showBusyDialog.name), {
        title: title,
        text: text,
        callID: callID
    })
}

// Hides the busy dialog.
function hideBusyDialog() {
    D.Dispatcher.dispatch(_type(hideBusyDialog.name), {})
}

//###############//
//### Private ###//
//###############//

// Returns the action type for the given function name of this script.
// Ret:
//  - string
function _type(funcName) {
    return "app" + funcName.capitalize()
}
