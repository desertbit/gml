.pragma library

.import Dispatcher as D

.import Action.Internal as AInternal

function view() {
    D.Dispatcher.dispatch(_type(view.name), {})
}

// Updates the network settings of the nLine device.
// Args:
//  - mode(enum)              : The network mode
//  - addr(string)            : The IP address, if mode is static
//  - subnetPrefixLength(int) : The length of the subnet prefix, if mode is static
//  - gateway(string)         : The IP address of the gateway, if mode is static
//  - dns(string)             : The DNS address, if mode is static
function updateNetwork(mode, addr, subnetPrefixLength, gateway, dns) {
    D.Dispatcher.dispatch(_type(updateNetwork.name), {
        mode: mode,
        addr: addr,
        subnetPrefixLength: subnetPrefixLength,
        gateway: gateway,
        dns: dns
    })
}

// Enables or disables the automatic autofocus before starting a new run.
// Args:
//  - enabled(bool) : Whether to enable or disable the autofocus
function setAutofocusBeforeStartRun(enabled) {
    D.Dispatcher.dispatch(_type(setAutofocusBeforeStartRun.name), { enabled: enabled })
}

// Sets the flip state of all cameras.
// Args:
//  - state(enum) : The desired flip state
function setCamerasFlipState(state) {
    D.Dispatcher.dispatch(_type(setCamerasFlipState.name), { state: state })
}

// Sets the alert and pause mode on the nLine device.
// Args:
//  - enabled(bool)     : Whether the alerd and pause mode is enabled
//  - eventCodes(array) : The codes on which the alert should trigger
function setAlertAndPause(enabled, eventCodes) {
    D.Dispatcher.dispatch(_type(setAlertAndPause.name), {
        enabled: enabled,
        eventCodes: eventCodes
    })
}

// Updates the default settings of the nLine device.
// Args:
//  - preset(int)       : The sensitivity preset value.
//  - sensitivity(int)  : The sensitivity using percentage (1-100)
//  - minDiameter(real) : The error min diameter
function updateDefaultProductSettings(preset, sensitivity, minDiameter) {
    D.Dispatcher.dispatch(_type(updateDefaultProductSettings.name), {
        sensitivityPreset: preset,
        customSensitivity: sensitivity,
        customSensitivityDiameterMin: minDiameter
    })
}

// Loads the default product settings.
function loadProductDefaultSettings() {
    D.Dispatcher.dispatch(_type(loadProductDefaultSettings.name),{})
}

// User wants to shutdown the connected nLine device.
function shutdownNLine() {
    D.Dispatcher.dispatch(_type(shutdownNLine.name), {})
}

// User wants to reboot the connected nLine device.
function rebootNLine() {
    D.Dispatcher.dispatch(_type(rebootNLine.name), {})
}

//################//
//### Internal ###//
//################//

// Loads the settings.
function load() {
    D.Dispatcher.dispatch(_type(load.name), {})
}

// Subscribes to the network interfaces of the nLine device.
function subscribeNetworkInterfaces() {
    D.Dispatcher.dispatch(_type(subscribeNetworkInterfaces.name), {})
}

// Unsubscribes to the network interfaces of the nLine device.
// Args:
//  - callID(int) : The callID of the Api stream.
function unsubscribeNetworkInterfaces(callID) {
    AInternal.emitCancel(callID)
}

//###############//
//### Private ###//
//###############//

// Returns the action type for the given function name of this script.
// Ret:
//  - string
function _type(funcName) {
    return "settings" + funcName.capitalize()
}
