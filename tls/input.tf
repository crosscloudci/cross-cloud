variable "tls_ca_cert_subject_common_name" {}
variable "tls_ca_cert_subject_locality" {}
variable "tls_ca_cert_subject_organization" {}
variable "tls_ca_cert_subject_organization_unit" { default = "CA" }
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


variable "tls_master_cert_subject_common_name" {}
variable "tls_master_cert_subject_locality" {}
variable "tls_master_cert_subject_organization" {}
variable "tls_master_cert_subject_organization_unit" {}
variable "tls_master_cert_subject_province" {}
variable "tls_master_cert_subject_country" {}
variable "tls_master_cert_validity_period_hours" {}
variable "tls_master_cert_early_renewal_hours" {}
variable "tls_master_cert_ip_addresses" {}
variable "tls_master_cert_dns_names" {}


variable "tls_worker_cert_subject_common_name" {}
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