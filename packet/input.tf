variable "name" { default = "packet" }

# Set with env TF_VAR_packet_project_id
variable "packet_project_id" {} # required for now
variable "packet_api_key" {}
# https://www.packet.net/locations/
variable "packet_facility" { default = "ewr1" }
variable "packet_billing_cycle" { default = "hourly" }
variable "packet_operating_system" { default = "coreos_stable" }
variable "packet_master_device_plan" { default = "baremetal_0" }
variable "packet_worker_device_plan" { default = "baremetal_0" }

variable "domain" { default = "cncf.packet" }
variable "data_dir" { default = "/cncf/data/packet" }

# VM Image and size

variable "master_node_count" { default = "3" }
variable "worker_node_count" { default = "3" }
# Autoscaling not supported by Kuberenetes on Azure yet
# variable "worker_node_min" { default = "3" }
# variable "worker_node_max" { default = "5" }

# Deployment Artifact Versions
# Hyperkube
# Set from https://quay.io/repository/coreos/hyperkube
