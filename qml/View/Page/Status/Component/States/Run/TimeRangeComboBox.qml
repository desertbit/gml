import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import View.Component.ComboBox as VCC

VCC.ComboBox {
    currentIndex: 0
    textRole: "text"
    valueRole: "value"
    model: [
        _.elem(qsTr("1 minute"),            60*1    ),
        _.elem(qsTr("%L1 minutes").arg(5),  60*5    ),
        _.elem(qsTr("%L1 minutes").arg(15), 60*15   ),
        _.elem(qsTr("%L1 minutes").arg(30), 60*30   ),
        _.elem(qsTr("1 hour"),              60*60   ),
        _.elem(qsTr("%L1 hours").arg(2),    60*60*2 ),
        _.elem(qsTr("%L1 hours").arg(4),    60*60*4 ),
        _.elem(qsTr("%L1 hours").arg(8),    60*60*8 ),
        _.elem(qsTr("%L1 hours").arg(24),   60*60*24)
    ]

    QtObject {
        id: _

        function elem(text, value) { return { text: text, value: value } }
    }
}
