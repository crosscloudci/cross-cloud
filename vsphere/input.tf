# General cluster settings
variable "name" { default = "vsphere" }
variable "data_dir" { default = "/cncf/data/vsphere" }

# vSphere Auth Settings
variable "vsphere_server" {}
variable "vsphere_user" {}
variable "vsphere_password" {}

# DNS Configuration
variable "etcd_server" { default = "147.75.69.23:2379" }
variable "discovery_nameserver" { default = "147.75.69.23" } 

# VM configuration
variable "datacenter" { default = "SDDC-Datacenter" }
variable "resource_pool" { default = "Compute-ResourcePool" }
variable "datastore_name" { default = "WorkloadDatastore" }
variable "virtual_machine_domain" { default = "vsphere.local" }
variable "virtual_machine_dns_servers" { default = [ "8.8.8.8",] }
variable "vm_folder" { default = "Workloads" }


# Master Configuration
variable "master_node_count" { default = "3" }
variable "master_network_name" { default  = "VMC Networks/sddc-cgw-network-1" }
variable "master_template_name" { default = "Templates/coreos_production_vmware_ova" }
variable "master_name_prefix" { default  = "master" }
variable "master_network_address" { default = "192.168.1.0/24" }
variable "master_ip_address_start" { default = "101" }
variable "master_gateway" { default = "192.168.1.1" }


# Worker Configuration
variable "worker_node_count" { default = "1" }
variable "worker_network_name" { default  = "VMC Networks/sddc-cgw-network-1" }
variable "worker_template_name" { default = "Templates/coreos_production_vmware_ova" }
variable "worker_name_prefix" { default  = "worker" }
variable "worker_network_address" { default = "192.168.1.0/24" }
variable "worker_ip_address_start" { default = "111" }
variable "worker_gateway" { default = "192.168.1.1" }

# Kubernetes configuration
variable "etcd_endpoint" {default = "127.0.0.1"}
variable "cloud_provider" { default = "vsphere" }
variable "cloud_config" { default = "--cloud-config=/etc/srv/kubernetes/cloud-config" }
variable "cluster_domain" { default = "cluster.local" }
variable "pod_cidr" { default = "100.96.0.0/11" }
variable "service_cidr"   { default = "100.64.0.0/13" }
variable "non_masquerade_cidr" { default = "100.64.0.0/10" }
variable "dns_service_ip" { default = "100.64.0.10" }

# Deployment Artifact Versions
variable "etcd_artifact" { default = "https://storage.googleapis.com/etcd/v3.2.8/etcd-v3.2.8-linux-amd64.tar.gz" }
variable "cni_artifact" { default = "https://github.com/containernetworking/cni/releases/download/v0.6.0/cni-amd64-v0.6.0.tgz" }
variable "cni_plugins_artifact" { default = "https://github.com/containernetworking/plugins/releases/download/v0.6.0/cni-plugins-amd64-v0.6.0.tgz" }

variable "kubelet_artifact" { default = "https://storage.googleapis.com/kubernetes-release/release/v1.10.1/bin/linux/amd64/kubelet" }
variable "kube_apiserver_artifact" { default = "https://storage.googleapis.com/kubernetes-release/release/v1.10.1/bin/linux/amd64/kube-apiserver" }
variable "kube_controller_manager_artifact" { default = "https://storage.googleapis.com/kubernetes-release/release/v1.10.1/bin/linux/amd64/kube-controller-manager" }
variable "kube_scheduler_artifact" { default = "https://storage.googleapis.com/kubernetes-release/release/v1.10.1/bin/linux/amd64/kube-scheduler"}
variable "kube_proxy_artifact" { default = "https://storage.googleapis.com/kubernetes-release/release/v1.10.1/bin/linux/amd64/kube-proxy"}

variable "kube_proxy_image" { default = "gcr.io/google_containers/kube-proxy"}
variable "kube_proxy_tag" { default = "v1.10.1"}

