#!/usr/bin/env bash

set -euo pipefail

if [ -f /usr/src/app/wireguard.ko ]
then
	modinfo /usr/src/app/wireguard.ko
	echo "wireguard.ko already exists, skipping module build..."
	exit 0
fi

if [ -n "${BALENA_DEVICE_TYPE:-}" ]
then
	echo "BALENA_DEVICE_TYPE is ${BALENA_DEVICE_TYPE}..."
	device_slug="${BALENA_DEVICE_TYPE}"
else
	echo "BALENA_DEVICE_TYPE is unset, skipping module build..."
	exit 0
fi

if [ -n "${BALENA_HOST_OS_VERSION:-}" ]
then
	echo "BALENA_HOST_OS_VERSION is ${BALENA_HOST_OS_VERSION}..."
	os_version="${BALENA_HOST_OS_VERSION##* }.${BALENA_HOST_OS_VARIANT:-prod}"
else
	echo "BALENA_HOST_OS_VERSION is unset, skipping module build..."
	exit 0
fi

src="$(find /usr/src/app/wireguard-linux-compat-* -maxdepth 1 -type d -name 'src')"

# download kernel sources from balena
curl -fsSL "https://files.balena-cloud.com/images/${device_slug}/${os_version/+/%2B}/kernel_source.tar.gz" \
	| tar xz --strip-components=2 -C /usr/src/app/

# build wireguard kernel module
make -C /usr/src/app/build modules_prepare -j"$(nproc)"
make -C /usr/src/app/build M="${src}" -j"$(nproc)"

mv "${src}/wireguard.ko" "/usr/src/app/"

# clean up kernel sources
rm -rf /usr/src/app/build
