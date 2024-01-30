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

goBuildTags() {
    # If dlv is enabled, the debug option is assumed to be so as well.
    [[ "${dlv}" == "true" ]] && debug=true

    # Parse and append additional build flags. 
    local tags="$(option ${static} 'static')"
    local tagDebug="$(option ${debug} 'debug')"
    local tagProfile="$(option ${profile} 'profile')"
    local separator="${tags:+,}"
    local tags="${tags}${tagDebug:+${separator}${tagDebug}}${tagProfile:+${separator}${tagProfile}}"

    echo ${tags}
}

##############
### Global ###
##############

# Ensure build and bin directories are present.
mkdir -p \
    "${ROOT}/bin" \
    "${ROOT}/build"

# Ensure a gopath is set.
if [[ "${GOPATH}" == "" ]]; then
    echo "no \$GOPATH set"
    exit 1
fi