#!/usr/bin/env bash

set -e
#set -x

########################################################################################################################
# Нещо уникално за вашия проект, например '-<факултетен номер на студента>'.
FACULTY_NUMBER="-471220028"
# Нещо уникално за вашия проект, например 'gitlab-<факултетен номер на студента>' ("gitlab-F1111111"_.
NAMESPACE="gitlab${FACULTY_NUMBER}"
# Name of the runner
GITLAB_RUNNER_NAME="tu-sofia-pis-2023-dev"
# Add gitlab runner token here: replace "TOKEN" with your registration token.
GITLAB_RUNNER_TOKEN="${GITLAB_RUNNER_TOKEN:-"UFmuo1CGnmPYsLHRsNY9"}"
########################################################################################################################

PROJECT_ID=$(gcloud config get-value core/project)

# NOTE: This doesn't work on MacOS. If this script doesn't work for you, please make the necessary changes in
#       "k8s/gitlab-runner.yaml", "k8s/gitlab-runner-config.yaml" and "k8s/gitlab-runner-gitlab-runner-role.yaml" files.
sed -i "s/\\\${FACULTY_NUMBER}/${FACULTY_NUMBER}/g" k8s/*.yaml
sed -i "s/\\\${GITLAB_RUNNER_NAME}/${GITLAB_RUNNER_NAME}/g" k8s/*.yaml
sed -i "s/\\\${GITLAB_RUNNER_TOKEN}/${GITLAB_RUNNER_TOKEN}/g" k8s/*.yaml
sed -i "s/\\\${PROJECT_ID}/${PROJECT_ID}/g" k8s/*.yaml
sed -i "s/\\\${NAMESPACE}/${NAMESPACE}/g" k8s/*.yaml

kubectl create namespace "${NAMESPACE}" || true
kubectl apply -f k8s --namespace "${NAMESPACE}"
$SHELL