# Cross Cloud Continuous Integration

### Why Cross-Cloud CI?

Our CI Working Group has been tasked with demonstrating best practices for integrating, testing, and deploying projects within the CNCF ecosystem across multiple cloud providers.

Help ensure the CNCF projects deploy and run sucessfully on each supported cloud providers.

### What is cross-cloud?

A project to continually validate the interoperability of each CNCF project, for every commit on stable and HEAD, for all supported cloud providers with the results published to the cross-cloud public dashboard. The cross-cloud project is composed of the following components:
- Cross-project CI - Project app and e2e test container builder / Project to Cross-cloud CI integration point
  * Builds and registers containerized apps as well as their related e2e tests for deployment. Triggers the cross-cloud CI pipeline.  
- Cross-cloud CI - Multi-cloud container deployer / Multi-cloud project test runner
  * Triggers the creation of k8s clusters on cloud providers, deploys containerized apps, and runs upstream project tests supplying results to the cross-cloud dashboard.
- Multi-cloud provisioner - Cloud end-point provisioner for Kubernetes
  * Supplies conformance validated Kubernetes end-points for each cloud provider with cloud specific features enabled
- Cross-cloud CI Dashboard - 
  * Provides a high-level view of the interoperability status of CNCF projects for each supported cloud provider.

### How to Use Cross-Cloud 

You have to have a working [Docker environment](https://www.docker.com/get-docker)


##### Quick start for AWS

**Pre-reqs:**
_[IAM User](https://console.aws.amazon.com/iam) with the following Permissions:_
- AmazonEC2FullAccess
- AmazonS3FullAccess
- AmazonRoute53DomainsFullAccess
- AmazonRoute53FullAccess
- IAMFullAccess
- IAMUserChangePassword

_AWS credentials_
```
export AWS_ACCESS_KEY_ID="YOUR_AWS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="YOUR_AWS_SECRET_KEY"
export AWS_DEFAULT_REGION=”YOUR_AWS_DEFAULT_REGION” # eg. ap-southeast-2
```

**Run the following to provision a Kubernetes cluster on AWS:**
```bash
docker run \
  -v /tmp/data:/cncf/data \
  -e NAME=cross-cloud
  -e CLOUD=aws    \
  -e COMMAND=deploy \
  -e BACKEND=file  \ 
  -e AWS_ACCESS_KEY_ID= $AWS_ACCESS_KEY_ID    \
  -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY    \
  -e AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION    \
  -ti registry.cncf.ci/cncf/cross-cloud/provisioning:ci-stable-v0-2-0
```


##### Quick start for GCE
 
**Pre-reqs:**
[Project created on Google Cloud](https://console.developers.google.com/projectcreate) (eg. test-cncf-cross-cloud)

_Google Cloud JSON configuration file for authentication._  (This file is downloaded directly from the [Google Developers Console](https://console.developers.google.com/))

1. Log into the Google Developers Console and select a project.
1. The API Manager view should be selected, click on "Credentials" on the left, then "Create credentials," and finally "Service account key."
1. Select "Compute Engine default service account" in the "Service account" dropdown, and select "JSON" as the key type.
1. Clicking "Create" will download your credentials.
1. Rename this file to credentials-gce.json and move to your home directory (~/credentials-gce.json)

_Google Project ID_

1. Log into the [Google Developers Console](https://console.developers.google.com/) to be sent to the [Google API library page](https://console.developers.google.com/apis/library) screen
1. Click the `Select a project` drop-down in the upper left
1. Copy the Project ID for the desired project from the window that shows
Eg. test-cncf-cross-cloud

**Run the following to provision a Kubernetes cluster on GCE:**
``` bash
export GOOGLE_CREDENTIALS=$(cat ~/credentials-gce.json)
docker run \
  -v /tmp/data:/cncf/data  \
  -e NAME=cross-cloud  \
  -e CLOUD=gce    \
  -e COMMAND=deploy  \
  -e BACKEND=file  \ 
  -e GOOGLE_REGION=us-central1    \
  -e GOOGLE_PROJECT=test-cncf-cross-cloud  \
  -e GOOGLE_CREDENTIALS=”${GOOGLE_CREDENTIALS}”
  -ti registry.cncf.ci/cncf/cross-cloud/provisioning:ci-stable-v0-2-0
```

#### General usage and configuration

Minimum required Configuration to use Cross-Cloud to Deploy a Kubernetes Cluster on Cloud X.
```bash
docker run \
  -v /tmp/data:/cncf/data \
  -e NAME=cross-cloud
  -e CLOUD=<aws|gke|gce|packet>    \
  -e COMMAND=<deploy|destory> \
  -e BACKEND=<file|s3>  \ 
  <CLOUD_SPECIFIC_OPTIONS>
  <KUBERNETES_CLUSTER_OPTIONS>
  -ti registry.cncf.ci/cncf/cross-cloud/provisioning:ci-stable-v0-2-0
```

#### Common Options
* -e CLOUD=<aws|gke|gce|packet> # Choose the cloud provider.  Then add the appropriate cloud specific options below.
* -e COMMAND=<deploy|destory>
* -e BACKEND=<file|s3>   # File will store the Terraform State file to Disk / S3 will store the Terraform Statefile to a AWS s3 Bucket
  

#### Cloud Specific Options
AWS:
 * -e AWS_ACCESS_KEY_ID=secret
 * -e AWS_SECRET_ACCESS_KEY=secret
 * -e AWS_DEFAULT_REGION=ap-southeast-2

Packet:
 * -e PACKET_AUTH_TOKEN=secret
 * -e TF_VAR_packet_project_id=secret 
 * -e DNSIMPLE_TOKEN=secret
 * -e DNSIMPLE_ACCOUNT=secret   

GCE/GKE:
 * -e GOOGLE_CREDENTIALS=secret
 * -e GOOGLE_REGION=us-central1
 * -e GOOGLE_PROJECT=test-163823

#### Kubernetes Cluster Options
Custom Configuration options for the Kubernetes Cluster:
* -e TF_VAR_pod_cidr=10.2.0.0/16      # Set the Kubernetes Cluster POD CIDR
* -e TF_VAR_service_cidr=10.0.0.0/24  # Set the Kubernetes Cluster SERVICE CIDR
* -e TF_VAR_worker_node_count=3       # Set the Number of Worker nodes to be Deployed in the Cluster
* -e TF_VAR_master_node_count=3       # Set the Number of Master nodes to be Deployed in the Cluster
* -e TF_VAR_dns_service_ip=10.0.0.10  # Set the Kubernetes DNS Service IP
* -e TF_VAR_k8s_service_ip=10.0.0.1   # Set the Kubernetes Service IP


### Additional Documentation

 * [FAQ](FAQ.md) - Frequently Asked Questions


### CI Status Dashboard Views
Current Phase: In Design/Planning

#### [Overview](/DASHBOARD.md#overview-screen)
![cncf-dashboard_web_overview_v3-2default-b](https://user-images.githubusercontent.com/26697/29292628-70ccb612-810d-11e7-869d-13e09894c93d.png)

#### [Deployment View](/DASHBOARD.md#deployment-view-screen)
![cncf-dashboard_web_deployment-view_v3-2-default](https://user-images.githubusercontent.com/26697/29292630-73bc201a-810d-11e7-8671-307f92a7ce11.png)

 * See the [Dashboard document](DASHBOARD.md) for additional Dashboard Views 

### Meetings / Demos

#### Upcoming
- September, 2017 CNCF/K8s Storage SIG Testing Group (TBD)
- September 11th-14th 2017 [Open Source Summit North America](http://events.linuxfoundation.org/events/open-source-summit-north-america)
- September 12th, 2017 - CNCF: Governing Board
- October 12th, 2017 - CNCF: End User Committee Meeting

#### Past
- [August 22nd, 2017 - CI-WG ii.coop Status Updates](https://docs.google.com/presentation/d/1MixvezbkqJP4VeA09kUd-Po18V3SLHS-nSlOnkzowms/edit#slide=id.g242b36cf7c_0_10)
- August 15th, 2017 - CNCF TOC
- [August 8th, 2017 - CI-WG ii.coop Status Updates](https://docs.google.com/presentation/d/1dgkeXN7qSJ8tSUTZ5ecB67D155Y0Mphrpqi9ZFZXWKo/edit#slide=id.g242b36cf7c_0_10)
- [July 11th, 2017 - Kubernetes SIG Testing](https://www.youtube.com/watch?v=DQGcv2a4qXQ&list=PL69nYSiGNLP0ofY51bEooJ4TKuQtUSizR&index=1)
- [June 27, 2017 - CI-WG cross-cloud and containerops demos](https://www.youtube.com/watch?v=Jc5EJVK7ZZk&feature=youtu.be&t=307)





