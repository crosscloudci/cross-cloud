variable "name" { default = "packet" }

variable "data_dir" { default = "/cncf/data/packet" }

# DNS Configuration
variable "etcd_server" { default = "147.75.69.23:2379" }
variable "discovery_nameserver" { default = "147.75.69.23" } 


variable "master_node_count" { default = "3" }
variable "worker_node_count" { default = "1" }

# Set with env TF_VAR_packet_project_id
variable "packet_project_id" {} # required for now
variable "packet_api_key" {}
# https://metal.equinix.com/product/locations/
variable "packet_facility" { default = "sjc1" }
variable "packet_billing_cycle" { default = "hourly" }


# VM Image and size
variable "packet_master_device_plan" { default = "c1.small.x86" }
variable "packet_worker_device_plan" { default = "m2.xlarge.x86" }
variable "packet_operating_system" { default = "ubuntu_18_04" }


# Kubernetes
variable "arch" { default = "" }
variable "cloud_provider" { default = "packet" }
variable "cloud_config" { default = "" }
variable "cluster_domain" { default = "cluster.local" }
variable "pod_cidr" { default = "100.96.0.0/11" }
variable "service_cidr"   { default = "100.64.0.0/13" }
variable "non_masquerade_cidr" { default = "100.64.0.0/10" }
variable "dns_service_ip" { default = "100.64.0.10" }


# Deployment Artifact Versions
variable "etcd_artifact" { default = "https://storage.googleapis.com/etcd/v3.3.11/etcd-v3.3.11-linux-amd64.tar.gz" }
variable "cni_artifact" { default = "https://github.com/containernetworking/cni/releases/download/v0.6.0/cni-amd64-v0.6.0.tgz" }
variable "cni_plugins_artifact" { default = "https://github.com/containernetworking/plugins/releases/download/v0.7.4/cni-plugins-amd64-v0.7.4.tgz" }

variable "kubelet_artifact" { default = "https://storage.googleapis.com/kubernetes-release/release/v1.13.0/bin/linux/amd64/kubelet" }
variable "kube_apiserver_artifact" { default = "https://storage.googleapis.com/kubernetes-release/release/v1.13.0/bin/linux/amd64/kube-apiserver" }
variable "kube_controller_manager_artifact" { default = "https://storage.googleapis.com/kubernetes-release/release/v1.13.0/bin/linux/amd64/kube-controller-manager" }
variable "kube_scheduler_artifact" { default = "https://storage.googleapis.com/kubernetes-release/release/v1.13.0/bin/linux/amd64/kube-scheduler"}
variable "kube_proxy_artifact" { default = "https://storage.googleapis.com/kubernetes-release/release/v1.13.0/bin/linux/amd64/kube-proxy"}

variable "kube_proxy_image" { default = "gcr.io/google_containers/kube-proxy"}
variable "kube_proxy_tag" { default = "v1.13.0"}
