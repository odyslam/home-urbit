#!/usr/bin/env bash
# File largely based on https://github.com/netdata/netdata/blob/master/packaging/docker/run.sh
set -e

if [ ! "${DO_NOT_TRACK:-0}" -eq 0 ] || [ -n "$DO_NOT_TRACK" ]; then
  touch /etc/netdata/.opt-out-from-anonymous-statistics
fi

# DOCKER_PGID=$(ls -nd /var/run/docker.sock | awk '{print $4}')
BALENA_PGID=$(ls -nd /var/run/balena.sock | awk '{print $4}')
re='^[0-9]+$'
if [[ $BALENA_PGID =~ $re ]] ; then
  echo "Netdata detected balena-engine.sock"
  DOCKER_HOST='/var/run/balena-engine.sock'
  PGID="$BALENA_PGID"
  export PGID
  export DOCKER_HOST
else
  echo "Netdata detected docker.sock"
  DOCKER_HOST="/var/run/docker.sock"
  PGID=$(ls -nd /var/run/docker.sock | awk '{print $4}')
  export PGID
  export DOCKER_HOST
fi

if [ -n "${PGID}" ]; then
  echo "Creating docker group ${PGID}"
  addgroup -g "${PGID}" "docker" || echo >&2 "Could not add group docker with ID ${PGID}, its already there probably"
  echo "Assign netdata user to docker group ${PGID}"
  usermod -a -G "${PGID}" "${DOCKER_USR}" || echo >&2 "Could not add netdata user to group docker with ID ${PGID}"
fi

if [ -n "${NETDATA_CLAIM_URL}" ] && [ -n "${NETDATA_CLAIM_TOKEN}" ] && [ ! -f /var/lib/netdata/cloud.d/claimed_id ]; then
  /usr/sbin/netdata-claim.sh -token="${NETDATA_CLAIM_TOKEN}" \
                             -url="${NETDATA_CLAIM_URL}" \
                             ${NETDATA_CLAIM_ROOMS:+-rooms="${NETDATA_CLAIM_ROOMS}"} \
                             ${NETDATA_CLAIM_PROXY:+-proxy="${NETDATA_CLAIM_PROXY}"} \
                             -daemon-not-running
fi

# Set ownership correctly; this handles the case where the volumes
# were attached to an earlier version of the container, with a
# different uid for the netdata user.
chown -R netdata:netdata /var/cache/netdata/
chown -R netdata:netdata /var/lib/netdata

chown -R netdata:root /var/lib/netdata/cloud.d
chmod -R 770 /var/lib/netdata/cloud.d/

exec /usr/sbin/netdata -u "${DOCKER_USR}" -D -s /host -p "${NETDATA_PORT}" -W set web "web files group" root -W set web "web files owner" root "$@"

