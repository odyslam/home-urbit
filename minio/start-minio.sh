#!/bin/bash
set -e
if [[ -z "${MINIO_ROOT_USER}" ]]; then
    export MINIO_ROOT_USER='urbit-home'
fi
if [[ -z "${MINIO_ROOT_PASSWORD}" ]]; then
    export MINIO_ROOT_PASSWORD='urbit-home'
fi
# start server
minio server /data
# Use the command bellow to start the container idle
# tail -f /dev/null