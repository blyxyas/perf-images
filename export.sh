#!/bin/bash

set -euxo

CONTAINER_ID=$(docker ps -a -f ancestor=benchmarker --format "{{.ID}}")

docker cp $CONTAINER_ID:/usr/rustc-perf/results/* /mnt/CDN/
docker cp $CONTAINER_ID:/usr/rustc-perf/results.db /mnt/CDN/
docker cp $CONTAINER_ID:/usr/rustc-perf/results.db-wal /mnt/CDN/
docker cp $CONTAINER_ID:/usr/rustc-perf/results.db-shm /mnt/CDN/

# Remove container
docker rm $CONTAINER_ID

echo "Exported successfuly"
