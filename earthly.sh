#!/bin/bash

docker run \
    --privileged --rm -t \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "$(pwd)":/workspace \
    -v earthly-tmp:/tmp/earthly:rw earthly/earthly:v0.7.20 \
    --allow-privileged "$@"
