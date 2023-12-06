#!/usr/bin/env bash

set -e

PROJECT_ID=$(gcloud config get-value core/project)

NODE_POOL_NAME=${1:-"${PROJECT_ID}-$(openssl rand -hex 8)"}
NODES_COUNT=${2:-"1"}
NODES_MACHINE_TYPE=${3:-"e2-standard-4"}
NODES_DISK_SIZE=${4:-"50"}
EXTRA_FLAGS=${5:-"--spot --enable-autoscaling --min-nodes ${NODES_COUNT} --max-nodes 4 --no-enable-autoupgrade --no-enable-autorepair"}
CLUSTER_NAME=${6:-"kubernetes"}
ZONE=${7:-"us-central1-a"}
SERVICE_ACCOUNT_NAME=${8:-"${PROJECT_ID}"}
SERVICE_ACCOUNT_EMAIL="${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"

gcloud container node-pools create "${NODE_POOL_NAME}" \
  --cluster=${CLUSTER_NAME} \
  --zone=${ZONE} \
  --service-account=${SERVICE_ACCOUNT_EMAIL} \
  --machine-type=${NODES_MACHINE_TYPE} \
  --image-type=cos_containerd \
  --disk-size=${NODES_DISK_SIZE} \
  --num-nodes=${NODES_COUNT} \
  --max-surge-upgrade 1 \
  --max-unavailable-upgrade 1 \
  ${EXTRA_FLAGS}
