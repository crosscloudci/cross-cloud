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

### How to Use Cross-Cloud TL;DR
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
  -ti registry.cncf.ci/cncf/cross-cloud/provisioning:ci-stable-v0-1-0
```

#### Common options
* -e CLOUD=<aws|gke|gce|packet> # Choose the cloud provider.  Then add the appropriate cloud specific options below.
* -e COMMAND=<deploy|destory>
* -e BACKEND=<file|s3>   # File will store the Terraform State file to Disk / S3 will store the Terraform Statefile to a AWS s3 Bucket
  

#### Cloud Specific Options
AWS
 * -e AWS_ACCESS_KEY_ID=secret
 * -e AWS_SECRET_ACCESS_KEY=secret
 * -e AWS_DEFAULT_REGION=ap-southeast-2

Packet:
 * -e PACKET_AUTH_TOKEN=secret
 * -e TF_VAR_packet_project_id=secret 
 * -e DNSIMPLE_TOKEN=secret
 * -e DNSIMPLE_ACCOUNT=secret   

GCE/GKE
 * -e GOOGLE_CREDENTIALS=secret
 * -e GOOGLE_REGION=us-central1
 * -e GOOGLE_PROJECT=test-163823

#### Kubernetes Cluster Options
Custom Configuration options for the Kubernetes Cluster
* -e TF_VAR_pod_cidr=10.2.0.0/16      # Set the Kubernetes Cluster POD CIDR
* -e TF_VAR_service_cidr=10.0.0.0/24  # Set the Kubernetes Cluster SERVICE CIDR
* -e TF_VAR_worker_node_count=3       # Set the Number of Worker nodes to be Deployed in the Cluster
* -e TF_VAR_master_node_count=3       # Set the Number of Master nodes to be Deployed in the Cluster
* -e TF_VAR_dns_service_ip=10.0.0.10  # Set the Kubernetes DNS Service IP
* -e TF_VAR_k8s_service_ip=10.0.0.1   # Set the Kubernetes Service IP


### Additional documentation

 * [FAQ](FAQ.md) - Frequently Asked Questions


### Meetings / Demos

#### Upcoming
- August 15th, 2017 - CNCF TOC
- September 11th-14th 2017 [Open Source Summit North America](http://events.linuxfoundation.org/events/open-source-summit-north-america)
- September 12th, 2017 - CNCF: Governing Board
- October 12th, 2017 - CNCF: End User Committee Meeting

#### Past
- [July 11th, 2017 - Kubernetes SIG Testing](https://www.youtube.com/watch?v=DQGcv2a4qXQ&list=PL69nYSiGNLP0ofY51bEooJ4TKuQtUSizR&index=1)
- [June 27, 2017 - CI-WG cross-cloud and containerops demos](https://www.youtube.com/watch?v=Jc5EJVK7ZZk&feature=youtu.be&t=307)
- [August 8th, 2017 - CI-WG ii.coop Status Updates](https://docs.google.com/presentation/d/1dgkeXN7qSJ8tSUTZ5ecB67D155Y0Mphrpqi9ZFZXWKo/edit#slide=id.g242b36cf7c_0_10)




