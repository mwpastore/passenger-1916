#!/bin/bash

set -euo pipefail

bundle install

# TODO: https://github.com/phusion/passenger/issues/1916
#export _PASSENGER_FORCE_HTTP_SESSION=true

instances=1
log_level=1

echo "Starting Passenger..."

bundle exec passenger start --log-level $log_level \
  --engine builtin --disable-turbocaching --disable-security-update-check \
  --spawn-method direct --max-pool-size $instances --min-instances $instances --max-request-queue-size 1024 \
  --address 127.0.0.1 --port 8080 --environment production &

echo "Waiting for Passenger..."

sleep 15

echo "Warming up..."

for i in $(seq 0 30) ; do
  curl -sSo /dev/null http://127.0.0.1:8080/plaintext
done

sleep 15

echo "Benchmarking..."

wrk -t12 -c400 -d30s http://127.0.0.1:8080/plaintext

echo "Stopping Passenger..."

bundle exec passenger stop --port 8080
