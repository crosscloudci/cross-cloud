variable "tls_ca_cert_subject_common_name" {}
variable "tls_ca_cert_subject_locality" {}
variable "tls_ca_cert_subject_organization" {}
variable "tls_ca_cert_subject_organization_unit" {}
variable "tls_ca_cert_subject_province" {}
variable "tls_ca_cert_subject_country" {}
variable "tls_ca_cert_validity_period_hours" {}
variable "tls_ca_cert_early_renewal_hours" {}


variable "tls_admin_cert_subject_common_name" {}
variable "tls_admin_cert_subject_locality" {}
variable "tls_admin_cert_subject_organization" {}
variable "tls_admin_cert_subject_organization_unit" {}
variable "tls_admin_cert_subject_province" {}
variable "tls_admin_cert_subject_country" {}
variable "tls_admin_cert_validity_period_hours" {}
variable "tls_admin_cert_early_renewal_hours" {}
variable "tls_admin_cert_ip_addresses" {} 
variable "tls_admin_cert_dns_names" {}


variable "tls_apiserver_cert_subject_common_name" {}
variable "tls_apiserver_cert_subject_locality" {}
variable "tls_apiserver_cert_subject_organization" {}
variable "tls_apiserver_cert_subject_organization_unit" {}
variable "tls_apiserver_cert_subject_province" {}
variable "tls_apiserver_cert_subject_country" {}
variable "tls_apiserver_cert_validity_period_hours" {}
variable "tls_apiserver_cert_early_renewal_hours" {}
variable "tls_apiserver_cert_ip_addresses" {}
variable "tls_apiserver_cert_dns_names" {}


variable "tls_controller_cert_subject_common_name" {}
variable "tls_controller_cert_subject_locality" {}
variable "tls_controller_cert_subject_organization" {}
variable "tls_controller_cert_subject_organization_unit" {}
variable "tls_controller_cert_subject_province" {}
variable "tls_controller_cert_subject_country" {}
variable "tls_controller_cert_validity_period_hours" {}
variable "tls_controller_cert_early_renewal_hours" {}
variable "tls_controller_cert_ip_addresses" {}
variable "tls_controller_cert_dns_names" {}


variable "tls_worker_cert_subject_common_name" {}
variable "tls_worker_cert_subject_common_name_suffix" {}
variable "tls_worker_cert_subject_locality" {}
variable "tls_worker_cert_subject_organization" {}
variable "tls_worker_cert_subject_organization_unit" {}
variable "tls_worker_cert_subject_province" {}
variable "tls_worker_cert_subject_country" {}
variable "tls_worker_cert_validity_period_hours" {}
variable "tls_worker_cert_early_renewal_hours" {}
variable "tls_worker_cert_ip_addresses" {}
variable "tls_worker_cert_dns_names" {}

variable "data_dir" {}
variable "master_node_count" {}
variable "worker_node_count" {}