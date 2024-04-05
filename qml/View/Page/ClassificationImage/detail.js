/**
 * nLine
 * 
 * Copyright (c) 2023 Wahtari GmbH
 * All rights reserved
 */

.import Action as A
.import Lib as L
.import Store as S

// Saves the current mapping of anomaly boxes to anomaly classes that the user has selected.
function save() {
    // Combine custom mapping and current state.
    // In order to remove a class from an anomaly box, the box 
    // must not be set inside the mapping.
    // Locally, this is represented by an unclassified anomaly class id.
    const mapping = {}
    S.Store.state.classificationImageDetail.anomalyBoxes.forEach(ab => {
        if (_.boxToClassMapping.hasOwnProperty(ab.id)) {
            const classID = _.boxToClassMapping[ab.id]
            if (classID !== L.Con.AnomalyClass.Unclassified) {
                mapping[ab.id] = classID
            }
            return
        }

        // Do not change this box.
        mapping[ab.id] = ab.anomalyClassID
    })
    A.AClassificationImageDetail.updateClasses(S.Store.state.classificationImageDetail.id, mapping).then(() => root.state = "")
}

// Updates the internal state with the newly selected class(es) for the given box.
function updateBoxToClassMapping(boxID, classIDs) {
    if (classIDs.empty()) {
        _.boxToClassMapping[boxID] = L.Con.AnomalyClass.Unclassified
    } else if (classIDs.length === 1) {
        _.boxToClassMapping[boxID] = classIDs[0]
    } else {
        console.error("only 1 class allowed to select")
        return
    }
    // Trigger property binding.
    _.boxToClassMapping = _.boxToClassMapping
}
