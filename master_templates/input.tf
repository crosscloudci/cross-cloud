variable "master_node_count" {}
variable "name" {}
variable "dns_suffix" {}
variable "hostname_suffix" {}

variable "kubelet_artifact" {}
variable "cni_artifact" {}
variable "etcd_registry" {}
variable "etcd_tag"  {}
variable "kube_apiserver_registry" {}
variable "kube_apiserver_tag" {}
variable "kube_controller_manager_registry" {}
variable "kube_controller_manager_tag" {}
variable "kube_scheduler_registry" {}
variable "kube_scheduler_tag" {}
variable "kube_proxy_registry" {}
variable "kube_proxy_tag" {}

variable "cloud_provider" {}
variable "cloud_config" {}
variable "cluster_domain" {}
variable "cluster_name" {}
variable "pod_cidr" {}
variable "service_cidr" {}
variable "non_masquerade_cidr" {}
variable "dns_service_ip" {}

variable "ca" {}
variable "ca_key" {}
variable "apiserver" {}
variable "apiserver_key" {}
variable "cloud_config_file" {}
