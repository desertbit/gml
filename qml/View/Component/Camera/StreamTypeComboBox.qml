import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

import Lib as L
import Store

import View.Component.ComboBox as VCC

// This ComboBox offers a way for the user to select a stream type for camera streams.
// It requires the caller to provide a stream type. This should be bound to the corresponding
// state stream type. This way, the box stays in sync with the state, should it be changed.
//
// The box automatically binds to the Store to check, if a run is active and whether it is paused.
// The model of the box then adjusts its elements to the state.
VCC.ComboBox {
    textRole: "text"
    valueRole: "value"

    // Build model depending on the state.
    model: _.model(Store.state.nline.state === L.State.Run)

    QtObject {
        id: _

        function elem(streamType) {
            return { text: L.Tr.streamType(streamType), value: streamType }
        }

        function model(runActive) {
            let m = [
                elem(L.Con.StreamType.Raw),
                elem(L.Con.StreamType.Locator),
                elem(L.Con.StreamType.Measurement)
            ]
            if (runActive) {
                m.push(elem(L.Con.StreamType.Defects))
                m.push(elem(L.Con.StreamType.DefectBoxes))
            }
            return m
        }
    }
}
