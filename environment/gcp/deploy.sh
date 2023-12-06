#!/usr/bin/env bash

set -e

PROJECT_ID=$(gcloud config get-value core/project)
INTERACTIVE=${1:-"false"}
DEPLOYMENT_NAME=${2:-"kubernetes"}

function interactive_deployment() {
  if [[ "${INTERACTIVE}" == "true" ]]; then
      gcloud $1 $2 --preview

      read -p "Continue with the deployment? (Y/n) " -n 1 -r
      [[ $REPLY =~ ^[Nn]$ ]] && exit 0

      gcloud $1
  else
      gcloud $1 $2
  fi
}

function apply_deployment () {
    if gcloud deployment-manager deployments describe $1; then
        interactive_deployment "deployment-manager deployments update $1 --delete-policy=ABANDON" "--config $2"
    else
        interactive_deployment "deployment-manager deployments create $1" "--config $2"
    fi
}

apply_deployment ${DEPLOYMENT_NAME} gdm/gke/${PROJECT_ID}.yaml
