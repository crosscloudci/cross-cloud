# OpenStack Script for Cross-Cloud Continuous Integration

## Getting Started

### Prerequisites

Building the CNCF/CICD cross-cloud container requires a recent version
of Docker. You will also need credentials for an OpenStack cloud with
Keystone, Nova, Neutron. LBaaSv2 is not yet supported in this module.

### Building the container

In the top-level directory,

```docker build . --tag provisioning```

### Configuring your cloud

You will need the following credentials for your OpenStack cloud.
These credentials will used to provision the Kubernetes cluster,
and will also be used for the OpenStack provider to Kubernetes.
In your environment, set the following OpenStack environment variables:

* `OS_AUTH_URL`
* `OS_REGION_NAME`
* `OS_USER_DOMAIN_NAME`
* `OS_USERNAME`
* `OS_PROJECT_NAME`
* `OS_PASSWORD`

Then assign them to Terraform variables like this:
* `TF_VAR_os_auth_url=$OS_AUTH_URL`
* `TF_VAR_os_region_name=$OS_REGION_NAME`
* `TF_VAR_os_user_domain_name=$OS_USER_DOMAIN_NAME`
* `TF_VAR_os_username=$OS_USERNAME`
* `TF_VAR_os_project_name=$OS_PROJECT_NAME`
* `TF_VAR_os_password=$OS_PASSWORD`

This deployment assumes you have a keypair available to inject into all
of the instances. The default name is `K8s`, but you may set it with the
variable `TF_VAR_keypair_name`.

This project assumes the existence of recent CoreOS release.
It defaults to the image named `CorsOS 1520.8.0`, but can be configured
with the variables:

* `TF_VAR_lb_image_name`
* `TF_VAR_master_image_name`
* `TF_VAR_worker_image_name`.

Similarly flavors (defaulting to `v1-standard-1`) can be set with:

* `TF_VAR_lb_flavor_name`
* `TF_VAR_master_flavor_name`
* `TF_VAR_worker_flavor_name`

Auto scaling is not supported, but you can control the number of master
and worker nodes with the variables:

* `TF_VAR_master_node_count`
* `TF_VAR_worker_node_count`

Network parameters include:

* `TF_VAR_bastion_floating_ip_pool`
* `TF_VAR_external_network_id`

As this is a multi-master deployment, a single load balancer is created
to proxy non-terminated TLS requests to the K8s master nodes. Given the
sporadic availability of LBaaSv2/Octavia across OpenStack clouds, the
load balancer is created manually rather than relying on the LBaaSv2
API.

### Deploying

The following script will deploy Kubernetes into your cloud:

```
#!/bin/bash
docker run \
  -v $(pwd)/data:/cncf/data \
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

### Connecting with `kubectl`

The deployment script will drop a `kubeconfig` file into
`$(pwd)/data/cross-cloud`. As root, make a copy of it into
a local location, change the ownership to your local user,
and export the `KUBECONFIG` environment variable. For example:

```
sudo cp $(pwd)/data/cross-cloud/kubeconfig ~/.
sudo chown $(whoami):$(whoami) ~/kubeconfig
export KUBECONFIG=~/kubeconfig
kubectl get nodes
```

### Destroying

The following script will destroy the Kubernetes deployment:

```
#!/bin/bash
docker run \
  -v $(pwd)/data:/cncf/data \
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
