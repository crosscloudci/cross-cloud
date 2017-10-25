variable "worker_node_count" {}
variable "name" {}

variable "kubelet_artifact" {}
variable "cni_artifact" {}
variable "kube_proxy_image" {}
variable "kube_proxy_tag" {}


variable "cloud_provider" {}
variable "cloud_config" {}
variable "cluster_domain" {}
variable "pod_cidr" {}
variable "non_masquerade_cidr" {}
variable "dns_service_ip" {}
variable "internal_lb_ip" {}

variable "ca" {}
variable "worker" {}
variable "worker_key" {}
variable "cloud_config_file" {}

variable "dns_worker" {}
variable "dns_conf" {}
variable "corefile" {}
variable "dns_etcd" {}
