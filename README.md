# cross-cloud
Cross Cloud Continuous Integration

#### What is cross-cloud?

This cross-cloud project aims to demonstrate cross-project compatibility in the CNCF by building, E2E testing and deploying selected CNCF projects to multiple clouds using continuous integration (CI).  The initial proof of concept is being done by deploying a Kubernetes cluster with CoreDNS and Prometheus to AWS and Packet. The eventual goal is to support all CNCF projects on AWS, Packet, GCE, GKE, Bluemix and Azure.

Our cross-cloud provisioning is accomplished with the terraform modules for [AWS](./aws), [Azure](./azure), [GCE](./gce), [GKE](./gke), [Packet](./packet) which deploy kubernetes using a common set of variables producing KUBECONFIGs for each.

[cross-cloud-pipeline](./docs/images/cross-cloud-pipeline.png)
