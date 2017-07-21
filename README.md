# cross-cloud
Cross Cloud Continuous Integration


#### What is cross-cloud?

This cross-cloud project aims to demonstrate cross-project compatibility in the
CNCF by building, E2E testing and deploying selected CNCF projects to multiple
clouds using continuous integration (CI). The initial proof of concept is being
done by deploying a Kubernetes cluster with CoreDNS and Prometheus to AWS and
Packet. The eventual goal is to support all CNCF projects on AWS, Packet, GCE,
GKE, Bluemix and Azure.

Our cross-cloud provisioning is accomplished with the Terraform modules for
[AWS](./aws), [GCE](./gce), [GKE](./gke), [Packet](./packet)
which deploy kubernetes using a common set of variables producing KUBECONFIGs
for each.


#### How to Use Cross-Cloud TL;DR
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
  

##### Cloud Specific Options
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

### Kubernetes Cluster Options
Custom Configuration options for the Kubernetes Cluster
* -e TF_VAR_pod_cidr=10.2.0.0/16      # Set the Kubernetes Cluster POD CIDR
* -e TF_VAR_service_cidr=10.0.0.0/24  # Set the Kubernetes Cluster SERVICE CIDR
* -e TF_VAR_worker_node_count=3       # Set the Number of Worker nodes to be Deployed in the Cluster
* -e TF_VAR_master_node_count=3       # Set the Number of Master nodes to be Deployed in the Cluster
* -e TF_VAR_dns_service_ip=10.0.0.10  # Set the Kubernetes DNS Service IP
* -e TF_VAR_k8s_service_ip=10.0.0.1   # Set the Kubernetes Service IP

