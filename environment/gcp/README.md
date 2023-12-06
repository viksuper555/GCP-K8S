# Create Google Kubernetes Engine (GKE) in Google Cloud Platform (GCP)

**!WARNING!**
**Files and steps in this directory are just for your information. GKE cluster is created and maintained by your teacher.**
**!WARNING!**

GKE cluster can be created either manually trough GCP console (web UI of GCP) or trough series of `gcloud` ([Google Cloud SDK](https://cloud.google.com/sdk)) 
commands. Those commands can be scripted with BASH scripts. This is what you can find in this directory.

Usually you can have this directory as separate GitLab repository, and you can manage the GKE cluster trough GitLab Pipelines. Each 
configuration change will trigger a GitLab Pipeline that will modify (create / update / delete) a GKE cluster for you automatically.
There are other approach to this, like using [Hashi Corp's Terraform](https://www.terraform.io/), however maintaining a series of steps 
as GitLab Pipeline is simpler and easier to understand.

For details on the exact steps that needs to be executed to create the GKE cluster, please refer to [.gitlab-ci.yml](.gitlab-ci.yml).

## Requirements

* **BASH** / ZSH (**Linux** / **Mac**)
* **Git BASH** (**preferred as Git is required anyway**) / cygwin / migwin (**Windows**)
* [A GCP project](https://console.cloud.google.com/home/dashboard?project=tu-sofia-pis-2023-dev) (**provided for that course by the teacher**)
* Google Cloud SDK
  * Google Cloud SDK requires Python, please refer to https://cloud.google.com/sdk/docs/install for more details

## Steps

### `gcloud` login to Google account

Run the bellow command and follow the instructions to authenticate and authorize `gcloud` with your Google account.

```shell
gcloud auth login
```

### `gcloud` project specific configuration

Run the bellow command and follow the instructions to add a project specific configuration.

```shell
gcloud config configurations create tu-sofia-pis-2023-dev
```

List available project specific configurations.

```shell
gcloud config configurations list
```

Activate a project specific configuration.

```shell
gcloud config configurations activate tu-sofia-pis-2023-dev
```

#### Update the project configuration

```shell
# Change the login account for the currently active configurations (might require to run "gcloud auth login")
gcloud config set account example@gmail.com
# Change the project name for the currently active configurations (this allows to run "gcloud config get-value 
# project" to get the current project name in the GKE deployment scripts)
gcloud config set project tu-sofia-pis-2023-dev
# Change the default GCP region for the currently active configurations
gcloud config set compute/region us-central1
# Change the default GCP zone for the currently active configurations
gcloud config set compute/zone us-central1-a
```

### Create GKE cluster with scripts

```shell
# Run script that will enable GCP APIs required by the project, such as GKE (it will do so for the currently active 
# gcloud project).
./enableapis.sh
# Run script that will create a GKE cluster (it will do so for the currently active gcloud project). Configuration 
# in "gdm/gke/$projectName.yaml" will be used to create the cluster.
./deploy.sh
# Create a service account for the project with specific IAM roles and Kubernetes Cluster Admin binding. It will be 
# used by GitLab Pipelines (with runners running on Kubernetes) to manage some aspects of the GCP project.
./iam.sh
```

### Add GKE cluster Node Pool

```shell
./deploy_node_pool.sh node-pool-2 
```
