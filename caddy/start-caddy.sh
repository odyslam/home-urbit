#!/bin/bash
set -e
if [[ -z "${BALENA_DEVICE_UUID}" ]]; then
  echo "Caddy is reverse proxying for domain: ${DOMAIN}"
else
  export DOMAIN=$(echo "${BALENA_DEVICE_UUID}.balena-devices.com")
  echo "Caddy is proxying for the balena public device URL"
  echo "Access your device from anywhere using this link:"
  echo "https://${BALENA_DEVICE_UUID}.balena-devices.com"
  echo "This feature is NOT activated by default. Read more on the balena documentation:"
  echo "https://www.balena.io/docs/learn/manage/actions/#enable-public-device-url"
fi
caddy run --config /etc/caddy/Caddyfile
