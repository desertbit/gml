#!/usr/bin/env bash

set -e

# If we are running docker natively, we want to create a user in the container
# with the same UID and GID as the user on the host machine, so that any files
# created are owned by that user. Without this they are all owned by root.
if [[ -n $UID ]] && [[ -n $GID ]]; then
    export HOME="/home/builder"
    groupadd -o -g $GID builder 2> /dev/null
    useradd -d "${HOME}" -o -m -g $GID -u $UID -s /bin/bash builder 2> /dev/null
    chown builder:builder /work 

    # Run the command as the specified user/group.
    exec sudo -E -H -u builder \
        env "PATH=$PATH" \
        env "LD_LIBRARY_PATH=$LD_LIBRARY_PATH" \
        "$@"
else
    # Just run the command as root.
    exec "$@"
fi