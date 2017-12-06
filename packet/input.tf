variable "name" { default = "packet" }

variable "data_dir" { default = "/cncf/data/packet" }


variable "master_node_count" { default = "3" }
variable "worker_node_count" { default = "1" }

# Set with env TF_VAR_packet_project_id
variable "packet_project_id" {} # required for now
variable "packet_api_key" {}
# https://www.packet.net/locations/
variable "packet_facility" { default = "ams1" }
variable "packet_billing_cycle" { default = "hourly" }


# VM Image and size
variable "packet_master_device_plan" { default = "baremetal_1" }
variable "packet_worker_device_plan" { default = "baremetal_1" }
variable "packet_operating_system" { default = "coreos_stable" }


# Kubernetes
variable "etcd_endpoint" {default = "internal.skydns.local"}
variable "cloud_provider" { default = "" }
variable "cloud_config" { default = "" }
variable "cluster_domain" { default = "cluster.local" }
variable "cluster_name" { default = "kubernetes" }
variable "pod_cidr" { default = "100.96.0.0/11" }
variable "service_cidr"   { default = "100.64.0.0/13" }
variable "non_masquerade_cidr" { default = "100.64.0.0/10"}
variable "dns_service_ip" { default = "100.64.0.10" }


# Deployment Artifact Versions
# Hyperkube
# Set from https://quay.io/repository/coreos/hyperkube
variable "kubelet_artifact" { default = "https://storage.googleapis.com/kubernetes-release/release/v1.8.1/bin/linux/amd64/kubelet" }
variable "cni_artifact" { default = "https://github.com/containernetworking/cni/releases/download/v0.5.2/cni-amd64-v0.5.2.tgz" }

variable "etcd_image" { default = "gcr.io/google_containers/etcd"}
variable "etcd_tag" { default = "2.2.1"}
variable "kube_apiserver_image" { default = "gcr.io/google_containers/kube-apiserver"}
variable "kube_apiserver_tag" { default = "v1.8.1"}
variable "kube_controller_manager_image" { default = "gcr.io/google_containers/kube-controller-manager"}
variable "kube_controller_manager_tag" { default = "v1.8.1"}
variable "kube_scheduler_image" { default = "gcr.io/google_containers/kube-scheduler"}
variable "kube_scheduler_tag" { default = "v1.8.1"}
variable "kube_proxy_image" { default = "gcr.io/google_containers/kube-proxy"}
variable "kube_proxy_tag" { default = "v1.8.1"}
