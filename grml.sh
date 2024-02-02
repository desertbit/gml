#!/bin/sh

#################
### Functions ###
#################

option() {
    if [[ "$1" == "true" ]] || [[ "$1" == "TRUE" ]] || [[ "$1" == "on" ]] || [[ "$1" == "ON" ]]; then
        echo "$2"
    else
        echo "$3"
    fi
}

version() {
    local tag="$(git tag --points-at HEAD)"
    local commit="$(git rev-parse --short=12 --verify HEAD)"
    echo "${tag:=${commit}}"
}

##############
### Global ###
##############

# Ensure build and bin directories are present.
mkdir -p \
    "${ROOT}/bin" \
    "${ROOT}/build"
