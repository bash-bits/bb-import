#!/bin/bash

cd test/files || exit 5
exec nginx \
    -p "$PWD/" \
    -c "$PWD/nginx.conf" \
    -g 'daemon off;'
