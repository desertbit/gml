/**
 * nLine
 * 
 * Copyright (c) 2023 Wahtari GmbH
 * All rights reserved
 */

.pragma library

.import Lib as L

const InitState = {}

function init(state) {
    L.Obj.copy(state, InitState)
}
