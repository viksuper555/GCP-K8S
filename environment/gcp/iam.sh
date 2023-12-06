#!/usr/bin/env bash

set -e

PROJECT_ID=$(gcloud config get-value core/project)
SERVICE_ACCOUNT_NAME="${PROJECT_ID}";
SERVICE_ACCOUNT_EMAIL="${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"

# Create IAM service account for the project
gcloud iam service-accounts create ${SERVICE_ACCOUNT_NAME} --display-name "PIS-2023 Kubernetes Cluster Account" || true;

# Add IAM roles to the project service account
export ROLES="
roles/compute.instanceAdmin.v1
roles/errorreporting.writer
roles/logging.logWriter
roles/monitoring.metricWriter
roles/stackdriver.resourceMetadata.writer
roles/clouddebugger.agent
roles/storage.objectViewer
";

for role in $ROLES; do
    gcloud projects add-iam-policy-binding ${PROJECT_ID} \
       --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
       --role=$role || echo "Failed to give service account permissions (needs owner permissions), do this manually.";
done;

# Add Kubernetes "cluster-admin" cluster role binding
kubectl create clusterrolebinding add-on-cluster-admin \
	--clusterrole=cluster-admin \
	--serviceaccount=kube-system:default || echo "\"add-on-cluster-admin\" already added."
