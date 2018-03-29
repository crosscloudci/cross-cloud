variable "master_node_count" {}
variable "name" {}
variable "etcd_endpoint" {}
variable "etcd_discovery" {}

variable "kubelet_artifact" {}
variable "cni_artifact" {}
variable "etcd_image" {}
variable "etcd_tag"  {}
variable "kube_apiserver_image" {}
variable "kube_apiserver_tag" {}
variable "kube_controller_manager_image" {}
variable "kube_controller_manager_tag" {}
variable "kube_scheduler_image" {}
variable "kube_scheduler_tag" {}
variable "kube_proxy_image" {}
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

variable "dns_conf" {}
variable "dns_dhcp" {}
