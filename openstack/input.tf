# General cluster settings
variable "name" { default = "openstack" }
variable "data_dir" { default = "/cncf/data/openstack" }

# OpenStack Auth Settings
variable "os_auth_url" {}
variable "os_region_name" {}
variable "os_user_domain_name" {}
variable "os_username" {}
variable "os_project_name" {}
variable "os_password" {}

# OpenStack fixtures
variable keypair_name { default = "cross-cloud" }

# TLS settings
variable "cloud_location" { default = "vexxhost.com" }

# Load Balancer Configuration
variable "lb_flavor_name" { default = "v1-standard-1" }
variable "lb_image_name" { default = "Container-Linux" }

# DNS Configuration
variable "etcd_server" { default = "147.75.69.23:2379" }
variable "discovery_nameserver" { default = "147.75.69.23" } 

# Master Configuration
variable "master_flavor_name" { default = "v1-standard-1" }
variable "master_image_name" { default = "Container-Linux" }
variable "master_node_count" { default = "3" }

# Worker Configuration
variable "worker_flavor_name" { default = "v1-standard-16" }
variable "worker_image_name"  { default = "Container-Linux" }
variable "worker_node_count" { default = "1" }

# Network resources
variable "public_floating_ip_pool" { default = "public" }
variable "external_network_id" { default = "6d6357ac-0f70-4afa-8bd7-c274cc4ea235" }
variable "external_lb_subnet_id" { default = "4083e5c2-41ef-4838-8844-d2d300d2fb06" }
variable "internal_network_cidr" { default = "10.240.0.0/16" }

# Kubernetes configuration
variable "etcd_endpoint" {default = "127.0.0.1"}
variable "cloud_provider" { default = "openstack" }
variable "cloud_config" { default = "--cloud-config=/etc/srv/kubernetes/cloud-config" }
variable "cluster_domain" { default = "cluster.local" }
variable "pod_cidr" { default = "100.96.0.0/11" }
variable "service_cidr"   { default = "100.64.0.0/13" }
variable "dns_service_ip" { default = "100.64.0.10" }

# Deployment Artifact Versions
variable "etcd_artifact" { default = "https://storage.googleapis.com/etcd/v3.2.8/etcd-v3.2.8-linux-amd64.tar.gz" }
variable "cni_artifact" { default = "https://github.com/containernetworking/cni/releases/download/v0.6.0/cni-amd64-v0.6.0.tgz" }
variable "cni_plugins_artifact" { default = "https://github.com/containernetworking/plugins/releases/download/v0.6.0/cni-plugins-amd64-v0.6.0.tgz" }

variable "kubelet_artifact" { default = "https://storage.googleapis.com/kubernetes-release/release/v1.10.0/bin/linux/amd64/kubelet" }
variable "kube_apiserver_artifact" { default = "https://storage.googleapis.com/kubernetes-release/release/v1.10.0/bin/linux/amd64/kube-apiserver" }
variable "kube_controller_manager_artifact" { default = "https://storage.googleapis.com/kubernetes-release/release/v1.10.0/bin/linux/amd64/kube-controller-manager" }
variable "kube_scheduler_artifact" { default = "https://storage.googleapis.com/kubernetes-release/release/v1.10.0/bin/linux/amd64/kube-scheduler"}
variable "kube_proxy_artifact" { default = "https://storage.googleapis.com/kubernetes-release/release/v1.10.0/bin/linux/amd64/kube-proxy"}

variable "kube_proxy_image" { default = "gcr.io/google_containers/kube-proxy"}
variable "kube_proxy_tag" { default = "v1.10.0"}

