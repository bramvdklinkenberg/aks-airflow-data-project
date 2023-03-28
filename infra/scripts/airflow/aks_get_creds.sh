#!/usr/bin/env bash

set -e

if ! az aks get-credentials \
    --resource-group "${RESOURCE_GROUP_NAME}" \
    --name "${AKS_RESOURCE_NAME}" \
    --overwrite-existing; then
    echo "Failed to get credentials for AKS cluster ${AKS_CLUSTER_NAME}"
fi
