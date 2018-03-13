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
variable keypair_name { default = "K8s" }

# TLS settings
variable "cloud_location" { default = "vexxhost.com" }

# Load Balancer Configuration
variable "lb_flavor_name" { default = "v1-standard-1" }
variable "lb_image_name" { default = "CoreOS 1520.8.0" }

# Master Configuration
variable "master_flavor_name" { default = "v1-standard-1" }
variable "master_image_name" { default = "CoreOS 1520.8.0" }
variable "master_node_count" { default = "3" }

# Worker Configuration
variable "worker_flavor_name" { default = "v1-standard-1" }
variable "worker_image_name"  { default = "CoreOS 1520.8.0" }
variable "worker_node_count" { default = "3" }

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

