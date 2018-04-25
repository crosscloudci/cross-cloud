variable "worker_node_count" {}
variable "hostname" {}
variable "hostname_suffix" {}
variable "hostname_path" {}

variable "kubelet_artifact" {}
variable "cni_artifact" {}
variable "cni_plugins_artifact" {}
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
variable "kubelet" {}
variable "kubelet_key" {}
variable "proxy" {}
variable "proxy_key" {}
variable "bootstrap" {}
variable "cloud_config_file" {}

variable "dns_conf" {}
variable "dns_dhcp" {}