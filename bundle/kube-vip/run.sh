#!/bin/bash

set -ex

K3S_MANIFEST_DIR=${K3S_MANIFEST_DIR:-/var/lib/rancher/k3s/server/manifests/}

getConfig() {
    local key=$1
    _value=$(kairos-agent config get "${key} | @json" | tr -d '\n')
    # Remove the quotes wrapping the value.
    _value=${_value:1:${#_value}-2}
    if [ "${_value}" != "null" ]; then
     echo "${_value}"
    fi 
    echo   
}

INTERFACE=""
EIP=""
ENABLED="true"

# renovate: depName=kube-vip repoUrl=https://kube-vip.github.io/helm-charts
VERSION="0.4.4"

templ() {
    local file="$3"
    local value=$2
    local sentinel=$1
    sed -i "s/@${sentinel}@/${value}/g" "${file}"
}

readConfig() {
    _version=$(getConfig kubevip.version)
    if [ "$_version" != "" ]; then
        VERSION=$_version
    fi

    _enabled=$(getConfig kubevip.enabled)
    if [ "$_enabled" != "" ]; then
        ENABLED=$_enabled
    fi

    _interface=$(getConfig kubevip.interface)
    if [ "$_interface" != "" ]; then
        INTERFACE=$_interface
    fi

    _eip=$(getConfig kubevip.eip)
    if [ "$_eip" != "" ]; then
        EIP=$_eip
    fi
}

mkdir -p "${K3S_MANIFEST_DIR}"

readConfig

# Copy manifests, and template them
for FILE in assets/*; do 
    templ "VERSION" "${VERSION}" "${FILE}"
    templ "ENABLED" "${ENABLED}" "${FILE}"
    templ "INTERFACE" "${INTERFACE}" "${FILE}"
    templ "EIP" "${EIP}" "${FILE}"
done;

cp -rf assets/* "${K3S_MANIFEST_DIR}"
