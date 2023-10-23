#!/bin/bash
set -ex

K3S_MANIFEST_DIR=${K3S_MANIFEST_DIR:-/var/lib/rancher/k3s/server/manifests/}
TEMP_DIR=$(mktemp -d)

# Render templates into a temporary directory
for FILE in templates/*; do 
    OUTFILE="$TEMP_DIR/${FILE##*/}"
    echo "Rendering $FILE to $OUTFILE"
    kairos-agent render-template -f "$FILE" > "$OUTFILE"
done;

# List rendered file
ls "$TEMP_DIR"

# Copy rendered manifests to output location
mkdir -p "$K3S_MANIFEST_DIR"
cp "$TEMP_DIR"/* "$K3S_MANIFEST_DIR"
