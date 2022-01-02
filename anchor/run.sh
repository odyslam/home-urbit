#!/usr/bin/env bash

set -euo pipefail

cleanup() {
    wg-quick down wg0 || true
}

trap "cleanup" TERM INT QUIT EXIT

info() {
    echo "[INFO] $1"
}

warn() {
    echo "[WARN] $1"
}

fatal() {
    echo "[FATAL] $1"
    tail -f /dev/null
}

do_insmod() {

	if lsmod | grep wireguard >/dev/null 2>&1
	then
		return 0
	fi

    if [ ! -f "${module_path}" ]
    then
        return 1
    fi

	modprobe udp_tunnel
	modprobe ip6_udp_tunnel

    modinfo "${module_path}"

	if ! insmod "${module_path}"
	then
		dmesg | grep wireguard
		return 1
	else
		dmesg | grep wireguard
		return 0
	fi
}

config_root=/etc/wireguard
server_template=/usr/src/app/templates/server.conf
peer_template=/usr/src/app/templates/peer.conf
buildmod_cmd=/usr/src/app/buildmod.sh
module_path=/usr/src/app/wireguard.ko

server_conf_path="${config_root}"/wg0.conf
server_key_path="${config_root}"/wg0.key
server_pub_path="${config_root}"/wg0.pub

if [ -n "${DISABLE_USERSPACE:-}" ]
then
    info "Removing wireguard-go userspace module..."
    rm /usr/bin/wireguard-go 2>/dev/null || true
fi

if ! do_insmod
then
	"${buildmod_cmd}" || warn "Failed to build Wireguard kernel module!"
fi

if ! do_insmod && [ -n "${DISABLE_USERSPACE:-}" ]
then
    fatal "Failed to load kernel module and userspace is disabled!"
    info "Check your Device Type and OS Version or unset DISABLE_USERSPACE."
fi

if ! do_insmod && [ -z "${DISABLE_USERSPACE:-}" ]
then
    warn "Using universal wireguard-go userspace module, performance may be impacted!"
    info "This can be disabled by setting DISABLE_USERSPACE to any value."
fi

if do_insmod
then
    info "Using Wireguard kernel module for maximum performance!"
fi

mkdir -p "${config_root}"

# lookup public ip if server host is not provided
if [ -z "${SERVER_HOST}" ] || [ "${SERVER_HOST}" = "auto" ]
then
    SERVER_HOST="$(curl -s icanhazip.com)"
fi

info "Assigning '${SERVER_HOST}' as host address..."

# restrict default file creation permissions
umask 077

# generate server keys if required
if [ ! -f "${server_key_path}" ]
then
    info "Generating new keys for server..."
    wg genkey | tee "${server_key_path}" | wg pubkey > "${server_pub_path}"
fi

eval "$(ipcalc --silent --network "${CIDR}")" # NETWORK
eval "$(ipcalc --silent --minaddr "${CIDR}")" # MINADDR
eval "$(ipcalc --silent --maxaddr "${CIDR}")" # MAXADDR
eval "$(ipcalc --silent --broadcast "${CIDR}")" # BROADCAST

SERVER_ADDRESS="${MINADDR}"
SERVER_PRIVKEY="$(cat "${server_key_path}")"
SERVER_PUBKEY="$(cat "${server_pub_path}")"

info "Assigning '${SERVER_ADDRESS}' as server address..."

AVAILABLE_IPS="$(./prips.sh "${MINADDR}" "${MAXADDR}")"

# remove server address from available addresses
# shellcheck disable=SC2001
AVAILABLE_IPS="$(sed "s/\b${SERVER_ADDRESS}\b//g" <<< "${AVAILABLE_IPS}")"

# substitute env vars in server template conf
export SERVER_ADDRESS SERVER_PRIVKEY
envsubst < "${server_template}" > "${server_conf_path}"

# determine if peers is a number or a list of names
case "${PEERS}" in
   (*[!0-9]*|'') PEERS=$(echo "${PEERS}" | tr ',' ' ') ;;
   (*)           PEERS=$(seq 1 "${PEERS}") ;;
esac

for peer in ${PEERS}
do
    # peer_id is used for filenames so remove special characters
    peer_id="peer_${peer//[^[:alnum:]_-]/}"
    peer_key_path="${config_root}"/"${peer_id}".key
    peer_pub_path="${config_root}"/"${peer_id}".pub
    peer_conf_path="${config_root}"/"${peer_id}".conf

    # genrate peer keys if required
    if [ ! -f "${peer_key_path}" ]
    then
        info "Generating new keys for ${peer_id}..."
        wg genkey | tee "${peer_key_path}" | wg pubkey > "${peer_pub_path}"
    fi

    PEER_PRIVKEY="$(cat "${peer_key_path}")"
    PEER_PUBKEY="$(cat "${peer_pub_path}")"
    PEER_ADDRESS="$(grep "Address" "${peer_conf_path}" 2>/dev/null | awk '{print $NF}')" || true

    # assign a new IP
    if [ -z "${PEER_ADDRESS}" ] || ! grep -wq "${PEER_ADDRESS}" <<< "${AVAILABLE_IPS}"
    then
        for addr in ${AVAILABLE_IPS}
        do
            # determine the first unused IP address
            PEER_ADDRESS="${addr}"
            grep -q "${PEER_ADDRESS}" "${config_root}"/*.conf || break
        done
    fi

    if [ -z "${PEER_ADDRESS}" ]
    then
        fatal "Failed to find unused IP address for ${peer_id}!"
    else
        info "Assigning '${PEER_ADDRESS}' as ${peer_id} address..."
    fi

    # remove peer address from available addresses
    # shellcheck disable=SC2001
    AVAILABLE_IPS="$(sed "s/\b${PEER_ADDRESS}\b//g" <<< "${AVAILABLE_IPS}")"

    # substitute env vars in peer template conf
    export PEER_ADDRESS PEER_PRIVKEY PEER_DNS SERVER_PUBKEY SERVER_HOST SERVER_PORT ALLOWEDIPS
    envsubst < "${peer_template}" > "${peer_conf_path}"

    # add peer to server conf
    cat >> "${server_conf_path}" << EOF

[Peer]
# ${peer}
PublicKey = ${PEER_PUBKEY}
AllowedIPs = ${PEER_ADDRESS}/32
EOF

done

mkdir -p /dev/net
TUNFILE=/dev/net/tun
[ ! -c ${TUNFILE} ] && mknod ${TUNFILE} c 10 200

# set file permissions
chmod 600 "${config_root}"/*

info "Bringing interface wg0 up..."
wg-quick up wg0

tail -f /dev/null
