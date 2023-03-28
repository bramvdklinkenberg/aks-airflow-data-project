#!/usr/bin/env bash

set -e

WEBSERVER_SECRET_KEY=$(python3 -c 'import secrets; print(secrets.token_hex(16))')
FERNET_KEY=$(python3 -c "from cryptography.fernet import Fernet; key = Fernet.generate_key(); print(key.decode())")

echo 'Add the Apache Airflow Helm repository'
helm repo add apache-airflow https://airflow.apache.org
helm repo update

if [[ "$DRY_RUN" == true ]]; then
    helm upgrade --install airflow airflow-stable/airflow \
        --dry-run \
        --namespace airflow \
        --create-namespace \
        --set "webserverSecretKey=$WEBSERVER_SECRET_KEY" \
        --set "fernetKey=$FERNET_KEY" \
        --set "webserver.defaultUser.email=$AIRFLOW_DEFAULT_USER_EMAIL"
else
    helm upgrade --install airflow airflow-stable/airflow \
        --namespace airflow \
        --create-namespace \
        --set "webserverSecretKey=$WEBSERVER_SECRET_KEY" \
        --set "fernetKey=$FERNET_KEY" \
        --set "webserver.defaultUser.email=$AIRFLOW_DEFAULT_USER_EMAIL"
fi



# Check if the airflow pods are running
echo 'Check if Airflow Pods are running!'
kubectl get pods -n airflow

