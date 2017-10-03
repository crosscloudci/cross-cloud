variable "location" {}
variable "subnet_id" {}
variable "name" {}
variable "master_vm_size" {}
variable "master_node_count" {}
variable "image_publisher" {}
variable "image_offer"     {}
variable "image_sku"       {}
variable "image_version"   {}
variable "availability_id" {}
variable "storage_account" {}
variable "storage_primary_endpoint" {}
variable "storage_container" {}
variable "cluster_domain" {}
variable "dns_service_ip" {}
variable "internal_tld" {}
variable "pod_cidr" {}
variable "service_cidr" {}
variable "non_masquerade_cidr" {}
variable "admin_username" {}
variable "kubelet_image_url" {}
variable "kubelet_image_tag" {}
# variable "etcd_security_group_id" {}
# variable "external_elb_security_group_id" {}
variable "ca" {}
variable "ca_key" {}
variable "etcd" {}
variable "etcd_key" {}
variable "apiserver" {}
variable "apiserver_key" {}
variable "data_dir" {}

variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "subscription_id" {}

variable "internal_lb_ip" {}

