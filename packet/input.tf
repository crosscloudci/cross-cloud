variable "name" { default = "packet" }

# Set with env TF_VAR_packet_project_id
variable "packet_project_id" {} # required for now
# https://www.packet.net/locations/
variable "packet_facility" { default = "sjc1" }
variable "packet_billing_cycle" { default = "hourly" }
variable "packet_operating_system" { default = "coreos_stable" }
variable "packet_master_device_plan" { default = "baremetal_0" }
variable "packet_worker_device_plan" { default = "baremetal_0" }

variable "domain" { default = "cncf.ci" }
variable "data_dir" { default = "/cncf/data/packet" }

# VM Image and size
variable "admin_username" { default = "core"}

# Kubernetes
variable "cluster_domain" { default = "cluster.local" }
variable "pod_cidr" { default = "10.2.0.0/16" }
variable "service_cidr"   { default = "10.3.0.0/24" }
variable "k8s_service_ip" { default = "10.3.0.1" }
variable "dns_service_ip" { default = "10.3.0.10" }
variable "master_node_count" { default = "3" }
variable "worker_node_count" { default = "3" }
# Autoscaling not supported by Kuberenetes on Azure yet
# variable "worker_node_min" { default = "3" }
# variable "worker_node_max" { default = "5" }

# Deployment Artifact Versions
# Hyperkube
# Set from https://quay.io/repository/coreos/hyperkube
variable "kubelet_image_url" { default = "quay.io/coreos/hyperkube"}
variable "kubelet_image_tag" { default = "v1.4.7_coreos.0"}
