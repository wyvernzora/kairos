#!/bin/bash
set -ex

K3S_MANIFEST_DIR=${K3S_MANIFEST_DIR:-/var/lib/rancher/k3s/server/manifests/}

mkdir -p "$K3S_MANIFEST_DIR"

# Copy manifests, and template them
for FILE in assets/*; do 
    kairos-agent render-template -f "$FILE" > "$K3S_MANIFEST_DIR/$(basename "$FILE")"
done;
