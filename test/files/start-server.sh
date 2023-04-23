#!/bin/bash

cd test || true
exec nginx -p "$PWD" -c "$PWD/nginx.conf" -g 'daemon off;'
