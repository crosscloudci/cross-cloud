# General settings
variable "name" { default = "openstack" }
variable "data_dir" { default = "/cncf/data/openstack" }

# TLS settings
variable "cloud_location" { default = "vexxhost.com" }

# Compute resources
variable "master_flavor_name" { default = "v1-standard-1" }
variable "master_image_name"  { default = "CoreOS 1298.6.0 (MoreOS) [2017-03-15]" }
variable "master_count"       { default = "3" }

variable "node_flavor_name" { default = "v1-standard-1" }
variable "node_image_name"  { default = "CoreOS 1298.6.0 (MoreOS) [2017-03-15]" }
variable "node_count"       { default = "3" }

# Network resources
variable "public_network"       { default = "6d6357ac-0f70-4afa-8bd7-c274cc4ea235" }
variable "private_network_cidr" { default = "192.168.11.0/24" }
variable "private_lb_ip"        { default = "192.168.11.250" }

# Kubernetes configuration
variable "etcd_endpoint" {default = "127.0.0.1"}
variable "cloud_provider" { default = "openstack" }
variable "cloud_config" { default = "--cloud-config=/etc/srv/kubernetes/cloud-config" }
variable "cluster_domain" { default = "cluster.local" }
variable "cluster_name" { default = "kubernetes" }
variable "pod_cidr" { default = "100.96.0.0/11" }
variable "service_cidr"   { default = "100.64.0.0/13" }
variable "non_masquerade_cidr" { default = "100.64.0.0/10"}
variable "dns_service_ip" { default = "100.64.0.10" }

# Deployment Artifact Versions
variable "kubelet_artifact" { default = "https://storage.googleapis.com/kubernetes-release/release/v1.8.1/bin/linux/amd64/kubelet" }
variable "cni_artifact" { default = "https://github.com/containernetworking/cni/releases/download/v0.5.2/cni-amd64-v0.5.2.tgz" }

variable "etcd_image" { default = "gcr.io/google_containers/etcd"}
variable "etcd_tag" { default = "2.2.1"}
variable "kube_apiserver_image" { default = "gcr.io/google_containers/kube-apiserver"}
variable "kube_apiserver_tag"   { default = "v1.8.1"}
variable "kube_controller_manager_image" { default = "gcr.io/google_containers/kube-controller-manager"}
variable "kube_controller_manager_tag" { default = "v1.8.1"}
variable "kube_scheduler_image" { default = "gcr.io/google_containers/kube-scheduler"}
variable "kube_scheduler_tag" { default = "v1.8.1"}
variable "kube_proxy_image" { default = "gcr.io/google_containers/kube-proxy"}
variable "kube_proxy_tag" { default = "v1.8.1"}

