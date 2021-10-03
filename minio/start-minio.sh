#!/bin/bash
set -e
if [[ -z "${MINIO_ROOT_USER}" ]]; then
    export MINIO_ROOT_USER='home-urbit'
fi
if [[ -z "${MINIO_ROOT_PASSWORD}" ]]; then
    export MINIO_ROOT_PASSWORD='home-urbit'
fi
# start server
minio server --console-address :9001 /data
# Use the command bellow to start the container idle
# tail -f /dev/null
