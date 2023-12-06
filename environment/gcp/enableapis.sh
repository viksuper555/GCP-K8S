#!/usr/bin/env bash

set -e

# More details about available APIs and their documentation can be found here: https://console.cloud.google.com/apis/library/browse

# admin.googleapis.com                 Manage Google Workspace account resources and audit usage. (https://console.cloud.google.com/apis/library/admin.googleapis.com)
# cloudresourcemanager.googleapis.com  Creates, reads, and updates metadata for Google Cloud Platform resource containers. (https://console.cloud.google.com/apis/library/cloudresourcemanager.googleapis.com)
# compute.googleapis.com               Compute Engine API. (https://console.cloud.google.com/apis/library/compute.googleapis.com)
# container.googleapis.com             Builds and manages container-based applications, powered by the open source Kubernetes technology. (https://console.cloud.google.com/apis/library/container.googleapis.com)
# deploymentmanager.googleapis.com     The Google Cloud Deployment Manager v2 API provides services for configuring, deploying, and viewing Google Cloud services and APIs via templates which specify deployments of Cloud resources. (https://console.cloud.google.com/apis/library/deploymentmanager.googleapis.com)
# iam.googleapis.com                   Manages identity and access control for Google Cloud Platform resources, including the creation of service accounts, which you can use to authenticate to Google and make API calls. (https://console.cloud.google.com/apis/library/iam.googleapis.com)

APIS="admin.googleapis.com cloudresourcemanager.googleapis.com compute.googleapis.com container.googleapis.com deploymentmanager.googleapis.com iam.googleapis.com"

gcloud services enable $APIS;
