#!/usr/bin/env bash

set -e
#set -x

########################################################################################################################
# Нещо уникално за вашия проект, например '-<факултетен номер на студента>'.
FACULTY_NUMBER=""
# Нещо уникално за вашия проект, например 'gitlab-<факултетен номер на студента>' ("gitlab-F1111111").
NAMESPACE="gitlab${FACULTY_NUMBER}"
# Name of the runner
GITLAB_RUNNER_NAME="tu-sofia-pis-2023-dev"
# Add gitlab runner token here: replace "TOKEN" with your registration token.
GITLAB_RUNNER_TOKEN="${GITLAB_RUNNER_TOKEN:-"TOKEN"}"
########################################################################################################################

PROJECT_ID=$(gcloud config get-value core/project)

# NOTE: This doesn't work on MacOS. If this script doesn't work for you, please make the necessary changes in
#       "k8s/gitlab-runner.yaml", "k8s/gitlab-runner-config.yaml" and "k8s/gitlab-runner-gitlab-runner-role.yaml" files.
sed -i "s/\\\${FACULTY_NUMBER}/${FACULTY_NUMBER}/g" k8s/*.yaml
sed -i "s/\\\${GITLAB_RUNNER_NAME}/${GITLAB_RUNNER_NAME}/g" k8s/*.yaml
sed -i "s/\\\${GITLAB_RUNNER_TOKEN}/${GITLAB_RUNNER_TOKEN}/g" k8s/*.yaml
sed -i "s/\\\${PROJECT_ID}/${PROJECT_ID}/g" k8s/*.yaml
sed -i "s/\\\${NAMESPACE}/${NAMESPACE}/g" k8s/*.yaml

# NOTE: Adding unique identifier to the name of k8s deployment and configuration is not required!
#       Since all deployments will have their unique namespaces, configuration and deployment names
#       for different projects will no clash. However it's would make it easier to distinguish
#       configs for different projects. Exception is the gitlab runner configuration in the
#       "k8s/gitlab-runner-config.yaml" file, in which the following should be changed:
#           1. namespace = "gitlab${FACULTY_NUMBER}"
#           2. "GOOGLE_APPLICATION_EMAIL=gitlab-runner${FACULTY_NUMBER}@tu-sofia-pis-2023-dev.iam.gserviceaccount.com"
#       The two ${UNIQUE_IDENTIFIER} should be replaced with your namespace and service account.
#
#       Those of you who already have working deployments can ignore this.

kubectl create namespace "${NAMESPACE}" || true
kubectl apply -f k8s --namespace "${NAMESPACE}"
