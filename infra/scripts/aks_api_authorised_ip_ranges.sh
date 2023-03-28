#!/usr/bin/env bash

set -e
set -o pipefail

CURRENT_IP_RANGE=$(az aks show \
                    --resource-group "${RESOURCE_GROUP_NAME}" \
                    --name "${AKS_RESOURCE_NAME}" \
                    -o json | jq -r '.apiServerAccessProfile.authorizedIpRanges[]')
GITHUB_RUNNER_IP=$(curl ifconfig.me)

if [[ "${CURRENT_IP_RANGE}" != *"${GITHUB_RUNNER_IP}"* ]]; then
    az aks update \
        --resource-group "${RESOURCE_GROUP_NAME}" \
        --name "${AKS_RESOURCE_NAME}" \
        --api-server-authorized-ip-ranges "${CURRENT_IP_RANGE},${GITHUB_RUNNER_IP}/32" \
        --only-show-errors
else
    echo "IP already added"
fi

