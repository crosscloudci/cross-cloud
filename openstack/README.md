# OpenStack Script for Cross-Cloud Continuous Integration

## Getting Started

### Prerequisites

Building the CNCF/CICD cross-cloud container requires a recent version
of Docker. You will also need the following credentials for an OpenStack
cloud with Keystone, Nova, Neutron, and LBaaSv2 (or Octavia).

### Building the container

In the top-level directory,

```docker build . --tag provisioning```

### Configuring your cloud

You will need a complete set of credentials for your OpenStack cloud.
Since the credentials will be used in the Kubernetes deployment, and
(as far as I can tell) Terraform providers do not support configuration
introspection, you will need to set the Terraform variables directly.
For example, if you have the following OpenStack environment variables
set:

* `OS_AUTH_URL`
* `OS_REGION_NAME`
* `OS_USER_DOMAIN_NAME`
* `OS_USERNAME`
* `OS_PROJECT_NAME`
* `OS_PASSWORD`

You could assign them to Terraform variables like this:
* `TF_VAR_os_auth_url=$OS_AUTH_URL`
* `TF_VAR_os_region_name=$OS_REGION_NAME`
* `TF_VAR_os_user_domain_name=$OS_USER_DOMAIN_NAME`
* `TF_VAR_os_username=$OS_USERNAME`
* `TF_VAR_os_project_name=$OS_PROJECT_NAME`
* `TF_VAR_os_password=$OS_PASSWORD`

The required configuration variables are:

* `os_auth_url`
* `os_region_name`
* `os_user_domain_name`
* `os_username`
* `os_project_name`
* `os_password`

This script is tuned to run on Vexxhost. Other variables you will
want to set if you're using a different cloud include:

* `bastion_flavor_name`
* `bastion_image_name`
* `bastion_floating_ip_pool`
* `master_flavor_name`
* `master_image_name`
* `master_node_count`
* `worker_flavor_name`
* `worker_image_name`
* `worker_node_count`
* `external_network_id`
* `external_lb_subnet_id`


### Deploying

The following script will deploy Kubernetes into your cloud:

```
#!/bin/bash
docker run \
  -v /tmp/data:/cncf/data \
  -e TF_VAR_os_auth_url=$OS_AUTH_URL \
  -e TF_VAR_os_region_name=$OS_REGION_NAME \
  -e TF_VAR_os_user_domain_name=$OS_USER_DOMAIN_NAME \
  -e TF_VAR_os_username=$OS_USERNAME \
  -e TF_VAR_os_project_name=$OS_PROJECT_NAME \
  -e TF_VAR_os_password=$OS_PASSWORD \
  -e CLOUD=openstack \
  -e COMMAND=deploy \
  -e NAME=cross-cloud \
  -e BACKEND=file \
  -ti provisioning
```

### Destroying

The following script will destroy the Kubernetes deployment:

```
#!/bin/bash
docker run \
  -v /tmp/data:/cncf/data \
  -e TF_VAR_os_auth_url=$OS_AUTH_URL \
  -e TF_VAR_os_region_name=$OS_REGION_NAME \
  -e TF_VAR_os_user_domain_name=$OS_USER_DOMAIN_NAME \
  -e TF_VAR_os_username=$OS_USERNAME \
  -e TF_VAR_os_project_name=$OS_PROJECT_NAME \
  -e TF_VAR_os_password=$OS_PASSWORD \
  -e CLOUD=openstack \
  -e COMMAND=deploy \
  -e NAME=cross-cloud \
  -e BACKEND=file \
  -ti provisioning
```
