import QtQml

import QtQuick.VirtualKeyboard
import QtQuick.VirtualKeyboard.Settings

import Store

InputPanel {
    Binding {
        target: VirtualKeyboardSettings
        property: "locale"
        value: Store.state.locale
    }
}