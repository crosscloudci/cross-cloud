variable "name" { default = "ci" }

# Set with env TF_VAR_packet_project_id
variable "packet_project_id" {} # required for now
variable "data_dir" { default = "/cncf/data/cross-cloud" }

variable "domain" { default = "cncf.ci" }
#variable "data_dir" { default = "/cncf/data/packet" }

# Kubernetes
variable "cluster_domain" { default = "cluster.local" }
variable "pod_cidr" { default = "10.2.0.0/16" }
variable "service_cidr"   { default = "10.3.0.0/24" }
variable "k8s_service_ip" { default = "10.3.0.1" }
variable "dns_service_ip" { default = "10.3.0.10" }
variable "master_node_count" { default = "3" }
variable "worker_node_count" { default = "3" }
# For clouds that support autoscaling
variable "worker_node_min" { default = "3" }
variable "worker_node_max" { default = "5" }

# Deployment Artifact Versions
# Hyperkube
# Set from https://quay.io/repository/coreos/hyperkube
variable "kubelet_image_url" { default = "quay.io/coreos/hyperkube"}
variable "kubelet_image_tag" { default = "v1.4.7_coreos.0"}
