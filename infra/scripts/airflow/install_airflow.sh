#!/usr/bin/env bash

set -e
set -o pipefail

SCRIPT_PATH="$(dirname "${BASH_SOURCE[0]}")"

echo 'Adding the Apache Airflow Helm repository...'
helm repo add apache-airflow https://airflow.apache.org
helm repo update

echo 'Applying Airflow Namespace'
kubectl create namespace "${AIRFLOW_K8S_NAMESPACE}" \
    --dry-run=client \
    -o yaml | kubectl apply --dry-run="$DRY_RUN" -f -


echo 'Applying Azure Secrets...'
kubectl create secret generic "$AZURE_CRED" \
    --from-literal=AZURE_CLIENT_ID="$AZURE_CLIENT_ID" \
    --from-literal=AZURE_CLIENT_SECRET="$AZURE_CLIENT_SECRET" \
    --from-literal=AZURE_TENANT_ID="$AZURE_TENANT_ID" \
    --from-literal=AIRFLOW__SECRETS__BACKEND="$AIRFLOW__SECRETS__BACKEND" \
    --from-literal=AIRFLOW__SECRETS__BACKEND_KWARGS="$AIRFLOW__SECRETS__BACKEND_KWARGS" \
    --namespace "$AIRFLOW_K8S_NAMESPACE" \
    --dry-run=client \
    -o yaml | kubectl apply --dry-run="$DRY_RUN" -o name -f -


if [[ "$DRY_RUN" == client ]]; then
    echo 'Helm linting Airflow Helm Chart...'
    helm lint airflow apache-airflow/airflow \
        --namespace "${AIRFLOW_K8S_NAMESPACE}" \
        --set "secret[0].envName=AZURE_CLIENT_ID,secret[0].secretName=$AZURE_CRED,secret[0].secretKey=AZURE_CLIENT_ID" \
        --set "secret[1].envName=AZURE_CLIENT_SECRET,secret[1].secretName=$AZURE_CRED,secret[1].secretKey=AZURE_CLIENT_SECRET" \
        --set "secret[2].envName=AZURE_TENANT_ID,secret[2].secretName=$AZURE_CRED,secret[2].secretKey=AZURE_TENANT_ID" \
        --set "secret[3].envName=AIRFLOW__SECRETS__BACKEND,secret[3].secretName=$AZURE_CRED,secret[3].secretKey=AIRFLOW__SECRETS__BACKEND" \
        --set "secret[4].envName=AIRFLOW__SECRETS__BACKEND_KWARGS,secret[4].secretName=$AZURE_CRED,secret[4].secretKey=AIRFLOW__SECRETS__BACKEND_KWARGS" \
        --set "webserver.defaultUser.password=$AIRFLOW_ADMIN_PASSWORD" \
        --set "webserverSecretKey=$WEBSERVER_SECRET_KEY" \
        --set "fernetKey=$FERNET_KEY" \
        -f "${SCRIPT_PATH}/values.yml" \
        --quiet \
        --debug

else
    echo 'Deploying Airflow Helm Chart...'
    helm upgrade --install airflow apache-airflow/airflow \
        --namespace "${AIRFLOW_K8S_NAMESPACE}" \
        --set "secret[0].envName=AZURE_CLIENT_ID,secret[0].secretName=$AZURE_CRED,secret[0].secretKey=AZURE_CLIENT_ID" \
        --set "secret[1].envName=AZURE_CLIENT_SECRET,secret[1].secretName=$AZURE_CRED,secret[1].secretKey=AZURE_CLIENT_SECRET" \
        --set "secret[2].envName=AZURE_TENANT_ID,secret[2].secretName=$AZURE_CRED,secret[2].secretKey=AZURE_TENANT_ID" \
        --set "secret[3].envName=AIRFLOW__SECRETS__BACKEND,secret[3].secretName=$AZURE_CRED,secret[3].secretKey=AIRFLOW__SECRETS__BACKEND" \
        --set "secret[4].envName=AIRFLOW__SECRETS__BACKEND_KWARGS,secret[4].secretName=$AZURE_CRED,secret[4].secretKey=AIRFLOW__SECRETS__BACKEND_KWARGS" \
        --set "webserver.defaultUser.password=$AIRFLOW_ADMIN_PASSWORD" \
        --set "webserverSecretKey=$WEBSERVER_SECRET_KEY" \
        --set "fernetKey=$FERNET_KEY" \
        -f "${SCRIPT_PATH}/values.yml" \
        --wait=false
fi

# Check if the airflow pods are running
if [[ $DRY_RUN == none ]]; then
    echo 'Checking if the Airflow pods are running...'
    kubectl get pods --namespace airflow
fi
