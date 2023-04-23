#!/bin/bash
# shellcheck disable=SC2034

#set -eu

./test/files/start-server.sh &
nginx_pid="$!"
nginx_addr="http://127.0.0.1:12006"

echo "nginx pid: $nginx_pid"

# wait for nginx to boot up
sleep 1

finish()
{
    echo "Killing Nginx (pid $nginx_pid)"
    kill "$nginx_pid"
    exit
}

trap finish EXIT INT QUIT

IMPORT_CACHE="$PWD/cache"
IMPORT_DEBUG=1
IMPORT_RELOAD=1
IMPORT_SERVER="${nginx_addr}"

source ./src/bb-import.sh test

# Test basic import
bb::import foo
test "$(foo)" = "foo"

# Test version import
bb::import foo@1.0.0
test "$(foo1)" = "foo1"

# Test 404
r=0
bb::import does_not_exist || r="$?"
test "$r" -ne 0

echo "All Tests Passed!"
