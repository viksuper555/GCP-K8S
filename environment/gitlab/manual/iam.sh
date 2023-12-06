#!/usr/bin/env bash
set -e
#set -x

########################################################################################################################
# Нещо уникално за вашия проект, например '-<факултетен номер на студента>'.
FACULTY_NUMBER="-471220028"
# Нещо уникално за вашия проект, например 'gitlab-<факултетен номер на студента>' ("gitlab-F1111111"_.
NAMESPACE="gitlab${FACULTY_NUMBER}"
########################################################################################################################

PROJECT_ID=$(gcloud config get-value core/project)
SERVICE_ACCOUNT_NAME="gitlab-runner${FACULTY_NUMBER}";
SERVICE_ACCOUNT_EMAIL="${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" # "gitlab-runner-F111111@tu-sofia-pis-2023-dev.iam.gserviceaccount.com"

gcloud iam service-accounts create ${SERVICE_ACCOUNT_NAME} --display-name "GitLab Runner ${FACULTY_NUMBER}" || true;

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
       --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
       --role='roles/owner' || echo "Failed to give service account permissions (needs owner permissions), do this manually";

kubectl create namespace ${NAMESPACE} || true

if kubectl describe secret google-key --namespace=${NAMESPACE} >/dev/null ; then
    echo -n "Kubernetes secret with name \"google-key\" in namespace \"${NAMESPACE}\" already exists. It won't be updated!";
else
    gcloud iam service-accounts keys create \
       --iam-account "${SERVICE_ACCOUNT_EMAIL}" \
       service-account.json

    kubectl create secret generic google-key --from-file service-account.json --namespace=${NAMESPACE}
fi;

if kubectl get clusterrolebinding ${NAMESPACE}-cluster-admin; then
    echo -n "Kubernetes cluster-admin role binding with name \"${NAMESPACE}-cluster-admin\" already exists."
else
    kubectl create clusterrolebinding ${NAMESPACE}-cluster-admin --clusterrole=cluster-admin --serviceaccount=${NAMESPACE}:default
fi;
$SHELL