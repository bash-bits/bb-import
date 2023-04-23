#!/bin/bash

cd test/files || true
exec nginx -p "$PWD/" -c "$PWD/nginx.conf" -g 'daemon off;'
