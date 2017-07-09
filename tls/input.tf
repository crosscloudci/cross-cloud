variable "tls_ca_cert_subject_common_name" {}
variable "tls_ca_cert_subject_organization" {}
variable "tls_ca_cert_subject_locality" {}
variable "tls_ca_cert_subject_province" {}
variable "tls_ca_cert_subject_country" {}
variable "tls_ca_cert_validity_period_hours" {}
variable "tls_ca_cert_early_renewal_hours" {}

variable "tls_etcd_cert_subject_common_name" {}
variable "tls_etcd_cert_validity_period_hours" {}
variable "tls_etcd_cert_early_renewal_hours" {}
variable "tls_etcd_cert_ip_addresses" {}
variable "tls_etcd_cert_dns_names" {}


variable "tls_client_cert_subject_common_name" {}
variable "tls_client_cert_validity_period_hours" {}
variable "tls_client_cert_early_renewal_hours" {}
variable "tls_client_cert_ip_addresses" {}
variable "tls_client_cert_dns_names" {}


variable "tls_apiserver_cert_subject_common_name" {}
variable "tls_apiserver_cert_validity_period_hours" {}
variable "tls_apiserver_cert_early_renewal_hours" {}
variable "tls_apiserver_cert_ip_addresses" {}
variable "tls_apiserver_cert_dns_names" {}


variable "tls_worker_cert_subject_common_name" {}
variable "tls_worker_cert_validity_period_hours" {}
variable "tls_worker_cert_early_renewal_hours" {}
variable "tls_worker_cert_ip_addresses" {}
variable "tls_worker_cert_dns_names" {}

variable "tls_serviceaccount_cert_subject_common_name" {}
variable "tls_serviceaccount_cert_validity_period_hours" {}
variable "tls_serviceaccount_cert_early_renewal_hours" {}
variable "tls_serviceaccount_cert_ip_addresses" {}
variable "tls_serviceaccount_cert_dns_names" {}


variable "data_dir" {}
