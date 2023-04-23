#!/bin/bash
realpath "${BASH_SOURCE[0]}"
cd test/files || exit 5
exec nginx \
    -p "$PWD/" \
    -c "$PWD/nginx.conf" \
    -g 'daemon off;'
