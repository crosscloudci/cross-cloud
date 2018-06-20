# General cluster settings
variable "name" {
  default = "vsphere"
}

variable "data_dir" {
  default = "/cncf/data/vsphere"
}

# vSphere Auth Settings
variable "vsphere_server" {}

variable "vsphere_user" {}
variable "vsphere_password" {}

variable "allow_unverified_ssl" {
  default = false
}

# AWS Auth Settings for the Load Balancer & Elastic IP
# This should be the account linked to the VMC SDDC.
variable "vsphere_aws_access_key_id" {}

variable "vsphere_aws_secret_access_key" {}

variable "vsphere_aws_region" {
  default = "us-west-2"
}

# vSphere Resource Pool Settings

# resource_pool_cpu_limit is the limit in MHz of CPU that
# an environment can consume
variable "resource_pool_cpu_limit" {
  default = "128000"
}

# resource_pool_memory_limit is the limit in MB of memory that
# an environment can consume
variable "resource_pool_memory_limit" {
  default = "262144"
}

# AWS Load Balancer & Elastic IP Settings

# lb_port is the port on which the load-balancer listens for incoming 
# connections
variable "lb_port" {
  default = "443"
}

# lb_subnet_id is the ID of the subnet to which the load balancer is
# attached
variable "lb_subnet_id" {
  default = "subnet-fdee56b6"
}

# lb_target_port is the port on which the back-end targets listen for
# incoming connections from the load balancer
variable "lb_target_port" {
  default = "443"
}

# lb_vpc_id is ID of the VPC to which the load balancer is attached
variable "lb_vpc_id" {
  default = "vpc-8f7048f6"
}

# DNS Configuration
variable "etcd_server" {
  default = "147.75.69.23:2379"
}

variable "discovery_nameserver" {
  default = "147.75.69.23"
}

# VM configuration
variable "datacenter" {
  default = "SDDC-Datacenter"
}

variable "resource_pool" {
  default = "CNCF Cross-Cloud"
}

variable "datastore_name" {
  default = "WorkloadDatastore"
}

variable "vm_folder" {
  default = "Workloads"
}

# Master Configuration
variable "master_num_cpu" {
  default = "16"
}

variable "master_num_cores_per_socket" {
  default = "8"
}

variable "master_memory" {
  default = "65536"
}

variable "master_node_count" {
  default = "3"
}

variable "master_network_name" {
  default = "VMC Networks/sddc-cgw-network-1"
}

variable "master_template_name" {
  default = "Templates/coreos_production_vmware_ova"
}

# Worker Configuration
variable "worker_num_cpu" {
  default = "16"
}

variable "worker_num_cores_per_socket" {
  default = "8"
}

variable "worker_memory" {
  default = "65536"
}

variable "worker_node_count" {
  default = "1"
}

variable "worker_network_name" {
  default = "VMC Networks/sddc-cgw-network-1"
}

variable "worker_template_name" {
  default = "Templates/coreos_production_vmware_ova"
}

# Kubernetes configuration
variable "etcd_endpoint" {
  default = "127.0.0.1"
}

variable "cloud_provider" {
  default = "vsphere"
}

variable "cloud_config" {
  default = "--cloud-config=/etc/srv/kubernetes/cloud-config"
}

variable "cluster_domain" {
  default = "cluster.local"
}

variable "pod_cidr" {
  default = "100.96.0.0/11"
}

variable "service_cidr" {
  default = "100.64.0.0/13"
}

variable "non_masquerade_cidr" {
  default = "100.64.0.0/10"
}

variable "dns_service_ip" {
  default = "100.64.0.10"
}

# Deployment Artifact Versions
variable "etcd_artifact" {
  default = "https://storage.googleapis.com/etcd/v3.2.8/etcd-v3.2.8-linux-amd64.tar.gz"
}

variable "cni_artifact" {
  default = "https://github.com/containernetworking/cni/releases/download/v0.6.0/cni-amd64-v0.6.0.tgz"
}

variable "cni_plugins_artifact" {
  default = "https://github.com/containernetworking/plugins/releases/download/v0.6.0/cni-plugins-amd64-v0.6.0.tgz"
}

variable "kubelet_artifact" {
  default = "https://storage.googleapis.com/kubernetes-release/release/v1.10.1/bin/linux/amd64/kubelet"
}

variable "kube_apiserver_artifact" {
  default = "https://storage.googleapis.com/kubernetes-release/release/v1.10.1/bin/linux/amd64/kube-apiserver"
}

variable "kube_controller_manager_artifact" {
  default = "https://storage.googleapis.com/kubernetes-release/release/v1.10.1/bin/linux/amd64/kube-controller-manager"
}

variable "kube_scheduler_artifact" {
  default = "https://storage.googleapis.com/kubernetes-release/release/v1.10.1/bin/linux/amd64/kube-scheduler"
}

variable "kube_proxy_artifact" {
  default = "https://storage.googleapis.com/kubernetes-release/release/v1.10.1/bin/linux/amd64/kube-proxy"
}

variable "kube_proxy_image" {
  default = "gcr.io/google_containers/kube-proxy"
}

variable "kube_proxy_tag" {
  default = "v1.10.1"
}
