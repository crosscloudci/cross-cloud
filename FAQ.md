# FREQUENTLY ASKED QUESTIONS

### Why Terraform for cross-cloud?

We chose Terraform to allow a third party to maintain the API level interaction with the cloud providers.

To be able to support the cloud-provider specific features offered by Aws/GCE/GKE/Azure, the Kubernetes Testing-SIG approach for bringing up Kubernetes clusters uses a combination of kops / kubernetes-anywhere, and kube-up to bring up clusters for multiple cloud providers.

Kops officially supports AWS (GCE and VSphere forthcoming)
Kubernetes-anywhere (GCE, Azure, vSphere)
Kube-up (Deprecated)

Where tools like kube-up/kops are focused on offering mutable infrastructure which will be continually updated without offering a clean environment for testing a new Kubernetes CI Release we have taken a different approach.

With Terraform + cloud-init we have taken an immutable approach to the infrastructure management/provisioning which allows us to very quickly iterate over new deployments on a per-commit basis.

Terraform supports templated cloud-init config across all clouds which reduces our dependency on provisioning code needing to connect back over ssh (salt/ansible etc). We supply cloud-init/userdata which supports installing software repos, configuring certificates, writing out files, and service creation. 

We’ll be providing more information in the future on the public Github project, http://github.com/cncf/cross-cloud.  In the meantime, we welcome more feedback and look forward to collaborating with the ContainerOps team within the CNCF landscape.


### What are the dependencies for your k8s clusters?

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


### How does cross-cloud configure a k8s cluster?  How does cross-cloud run a k8s cluster?

The configuration for each k8s cluster is customized to support cloud-provider specific features.  

Then the k8s cluster is configured and provisioned for each cloud with Terraform using cloud-init with the cloud specific configuration.  (See “Why Terraform for cross-cloud” for more information on this topic).

The Kubelet binary is started by Systemd.  Kubelet starts the remaining Kubernetes components from the manifest files which were written to disk during provisioning.


### What are the primary components of cross-cloud project?

- Cross-project CI - Build and registers containerized apps as well as their related e2e tests for Kubernetes. Triggers cross-cloud CI pipeline.  
- Cross-cloud CI - Triggers creation of k8s on cloud providers, deploys containerized apps, and deploys e2e tests containers on the k8s end-points.
- K8s end-point provisioner - Creates k8s clusters with cloud specific features enabled per cloud provider.


### What do cross-cloud and cross-project components test?

The cross-project runs project specific CI tests.

The cross-cloud project runs e2e tests for the project on each cloud.

For Kubernetes cross-cloud runs the k8s conformance test from upstream Kubernetes for each cloud after the cluster has been provisioned.


### How does someone get started using the cross-cloud project?
See the TL;DR section in the README https://github.com/cncf/cross-cloud/#how-to-use-cross-cloud-tldr


### What are the cloud-providers targeted by cross-cloud project?
Currently the cross-cloud k8s end-point provisioner supports
- AWS
- GCE
- GKE
- Packet

Additional cloud-providers will be added. We welcome pull requests to add new ones. :)

