# FREQUENTLY ASKED QUESTIONS

### How does someone get started using the cross-cloud project?
See the [TL;DR section in the README](README.md#how-to-use-cross-cloud-tldr)

### Why Cross-Cloud CI?

Our CI Working Group has been tasked with demonstrating best practices for integrating, testing, and deploying projects within the CNCF ecosystem across multiple cloud providers.

Help ensure the CNCF projects deploy and run sucessfully on each supported cloud providers.

### What is cross-cloud?

A project to continually validate the interoperability of each CNCF project, for every commit on stable and HEAD, for all supported cloud providers with the results published to the cross-cloud public dashboard. The cross-cloud project is composed of the following components:
- Cross-project CI - Project app and e2e test container builder / Project to Cross-cloud CI integration point
  * Builds and registers containerized apps as well as their related e2e tests for deployment. Triggers the cross-cloud CI pipeline.  
- Cross-cloud CI - Multi-cloud container deployer / Multi-cloud project test runner
  * Triggers the creation of K8s clusters on cloud providers, deploys containerized apps, and runs upstream project tests supplying results to the cross-cloud dashboard.
- Multi-cloud provisioner - Cloud end-point provisioner for Kubernetes
  * Supplies conformance validated Kubernetes end-points for each cloud provider with cloud specific features enabled
- Cross-cloud CI Dashboard - 
  * Provides a high-level view of the interoperability status of CNCF projects for each supported cloud provider.

### What are the cloud-providers targeted by cross-cloud project?
Currently the cross-cloud K8s end-point provisioner supports
- AWS
- GCE
- GKE
- Packet

Additional cloud-providers will be added. We welcome pull requests to add new ones. :)

### What do cross-cloud and cross-project components test?

The cross-project runs project specific CI tests.

The cross-cloud project runs e2e tests for the project on each cloud.

For Kubernetes cross-cloud runs the K8s conformance test from upstream Kubernetes for each cloud after the cluster has been provisioned.

### Why Terraform for the multi-cloud provisioner?

It allows a third party to maintain the API level interaction with the cloud providers.

It supports [cloud-provider specific features](https://kubernetes.io/docs/getting-started-guides/scratch/#cloud-provider) offered by Aws/GCE/GKE/Azure.

It supports [templated cloud-init config](https://www.terraform.io/docs/providers/template/d/cloudinit_config.html) across all clouds.

### Why cloud-init for the multi-cloud provisioner?

To take an immutable approach to the infrastructure management/provisioning which allows us to very quickly iterate over new deployments on a per-commit basis.

It reduces our dependency on provisioning code needing to connect back over ssh (salt/ansible etc). 

It supports [installing software repos](http://cloudinit.readthedocs.io/en/latest/topics/examples.html#adding-a-yum-repository), [configuring certificates](http://cloudinit.readthedocs.io/en/latest/topics/examples.html#configure-an-instances-trusted-ca-certificates), [writing out files](http://cloudinit.readthedocs.io/en/latest/topics/examples.html#writing-out-arbitrary-files), and service creation. 

### What are the dependencies for your K8s clusters?

The entire list is cloud dependent since we support per-cloud feature sets.  

The base list of dependencies common for each cloud is:
- CNI
- Kubelet
- Etcd
- Kube API server
- Kube control manager
- Kube scheduler
- Kube proxy
- Containerd/Docker

### What version of X component are you using in the cross-cloud K8s clusters?
Cross-cloud uses pinning to set version being used.  This can be any commit, branch, tag or release. 

### How does cross-cloud configure a K8s cluster?  How does cross-cloud run a K8s cluster?

The configuration for each K8s cluster is customized to support cloud-provider specific features.  

Then the K8s cluster is configured and provisioned for each cloud with Terraform using cloud-init with the cloud specific configuration.  (See “Why Terraform for cross-cloud” for more information on this topic).

The Kubelet binary is started by Systemd.  Kubelet starts the remaining Kubernetes components from the manifest files which were written to disk during provisioning.

### Can I limit resources used when running the cross-cloud/cross-project CI/CD? 
Yes. Resource limiting includes
- Control the total number of running pipelines
- Control of the number of nodes used in a Kubernetes cluster
- Control over the number of cloud-provider’s provisioned
- Control the cloud providers being used

### Does the cross-cloud project use Jenkins or CircleCI?
No it does not use Jenkins or CircleCI.

The current implementation uses GitLab runners.

### What does typical CI environment look like?

## How many instances are needed? 
- 2 clusters, 8 nodes (total)
- 3 master nodes  
- 1 worker node
  - We are using 1 worker node because ONAP requires 1, but 3 worker nodes would be ideal in the future

## How big are the instances?
- 64GB of RAM per node
- 16-cores

## How much memory is used?
- Full usage, but we can shrink master nodes to use 10 CPU minimum
- Workers need to be 64 GB at least (ONAP needs that minimum to deploy)

### How do I add a new cloud? 
- Determine if a terraform module will work for the new cloud environment
- Review how terraform templates were built
- Look at how to do auth
- Create sub-folder for the new cloud environment

### Are there any examples of how to add a new cloud?
- For reference, see OpenStack’s PRs:
  - https://github.com/crosscloudci/cross-cloud/pull/111
  - https://github.com/crosscloudci/cross-cloud/pull/128 
  - https://github.com/crosscloudci/cross-cloud/pull/134 

### What does success for the new cloud look like?
- New cloud can run terraform apply on cluster, 
- Cloud resources are successfully allocated,
- K8s is deployed installed to provisioned systems,
- Installing helm to k8s cluster is successful,
- New cloud can run K8s conformance tests

### Are K8s clusters showing on internet?
- Yes, they have public IPs
- Store public IPs, query DNS records, find end point

### References: 
https://github.com/crosscloudci/cross-cloud/blob/master/README.md
https://github.com/crosscloudci/cross-cloud/pull/111
https://github.com/crosscloudci/cross-cloud/pull/128 
https://github.com/crosscloudci/cross-cloud/pull/134 
