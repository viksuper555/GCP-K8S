#!/usr/bin/env bash

set -e
#set -x

########################################################################################################################
# Нещо уникално за вашия проект, например '-<факултетен номер на студента>'.
FACULTY_NUMBER=""
# Нещо уникално за вашия проект, например 'gitlab-<факултетен номер на студента>' ("gitlab-F1111111"_.
NAMESPACE="gitlab-runner${FACULTY_NUMBER}"
# Name of the runner
GITLAB_RUNNER_NAME="tu-sofia-pis-2023-dev-helm-chart"
# Add gitlab runner token here: replace "TOKEN" with your registration token.
GITLAB_RUNNER_REGISTRATION_TOKEN="${GITLAB_RUNNER_REGISTRATION_TOKEN:-"GR1348941cR2f9ypbhRKoyNZx6xfu"}"
########################################################################################################################

PROJECT_ID=$(gcloud config get-value core/project)

# NOTE: This doesn't work on MacOS. If this script doesn't work for you, please make the necessary changes in
#       "values.yaml" file.
sed -i "s/\\\${FACULTY_NUMBER}/${FACULTY_NUMBER}/g" values.yaml
sed -i "s/\\\${GITLAB_RUNNER_NAME}/${GITLAB_RUNNER_NAME}/g" values.yaml
sed -i "s/\\\${GITLAB_RUNNER_REGISTRATION_TOKEN}/${GITLAB_RUNNER_REGISTRATION_TOKEN}/g" values.yaml
sed -i "s/\\\${PROJECT_ID}/${PROJECT_ID}/g" values.yaml
sed -i "s/\\\${NAMESPACE}/${NAMESPACE}/g" values.yaml

kubectl create namespace ${NAMESPACE} || true

helm install --namespace ${NAMESPACE} gitlab-runner-helm-chart -f values.yaml gitlab/gitlab-runner || \
  helm upgrade --install --namespace ${NAMESPACE} gitlab-runner-helm-chart -f values.yaml gitlab/gitlab-runner
