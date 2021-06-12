#!/bin/bash
set -e
if [[ -z "${NGINX_USER}" ]]; then
    export NGINX_USER='home-urbit'
    echo "NGINX_USER is set to default value: $NGINX_USER"
fi
if [[ -z "${NGINX_PASSWORD}" ]]; then
    export NGINX_PASSWORD='home-urbit'
    echo "NGINX_PASSWORD is set to default value: $NGINX_PASSWORD"
fi
  
htpasswd -b -c /etc/nginx/.htpasswd "$NGINX_USER" "$NGINX_PASSWORD"
nginx -g 'daemon off;'