#!/bin/bash

# This script will find and remove files older than 100 days under the /dummy directory on a specific build slave

USER=user
HOST=""

if [[ -n $1 ]]; then
    echo "Selected hostname: " $1
    HOST=$1
else
    echo "Error: please provide a slave hostname!"
    exit 1
fi

echo "Removing files older than 100 days from $HOST:/dummy ..."
ssh $USER@$HOST "find /dummy -type f -mtime +100 | xargs rm -vf"
