= FREQUENTLY ASKED QUESTIONS

=== Why Terraform for cross-cloud?

We chose terraform to allow a third party to maintain the API level interaction with the cloud providers.

To be able to support the cloud-provider specific features offered by Aws/GCE/GKE/Azure, the Kubernetes Testing-SIG approach for bringing up Kubernetes clusters uses a combination of kops / kubernetes-anywhere, and kube-up to bring up clusters for multiple cloud providers.

Kops officially supports AWS (GCE and VSphere forthcoming)
Kubernetes-anywhere (GCE, Azure, vSphere)
Kube-up (Deprecated)

Where tools like kube-up/kops are focused on offering mutable infrastructure which will be continually updated without offering a clean environment for testing a new Kubernetes CI Release we have taken a different approach.

With Terraform + cloud-init we have taken an immutable approach to the infrastructure management/provisioning which allows us to very quickly iterate over new deployments on a per-commit basis.

Terraform supports templated cloud-init config across all clouds which reduces our dependency on provisioning code needing to connect back over ssh (salt/ansible etc). We supply cloud-init/userdata which supports installing software repos, configuring certificates, writing out files, and service creation. 

We’ll be provide more information in the future on the public Github project, http://github.com/cncf/cross-cloud.   In the meantime we welcome more feedback and look forward to collaborating with the ContainerOps team within the CNCF landscape.
