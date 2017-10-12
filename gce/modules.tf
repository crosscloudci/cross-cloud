module "vpc" {
  source = "./modules/vpc"
  name = "${ var.name }"
  cidr = "${ var.cidr }"
  region = "${ var.region }"
 }

 module "master" {
   source = "./modules/master"
   name = "${ var.name }"
   region = "${ var.region }"
   zone = "${ var.zone }"
   project = "${ var.project }"
   network = "${ module.vpc.network }"
   subnetwork = "${ module.vpc.subnetwork }"
   master_vm_size = "${ var.master_vm_size }"
   master_node_count = "${ var.master_node_count }"
   image_id = "${ var.image_id }"
   internal_lb_ip = "${ var.internal_lb_ip }"
}

module "bastion" {
  source = "./modules/bastion"
  name = "${ var.name }"
  bastion_vm_size = "${ var.bastion_vm_size }"
  zone = "${ var.zone }"
  image_id = "${ var.image_id }"
  project = "${ var.project }"
}

# module "worker" {
#   source = "./modules/worker"
#   name = "${ var.name }"
#   region = "${ var.region }"
#   zone = "${ var.zone }"
#   project = "${ var.project }"
#   worker_node_count = "${ var.worker_node_count }"
#   internal_lb_ip = "${ var.internal_lb_ip }"
#   # security-group-id = "${ module.security.worker-id }"
# }

module "security" {
  source = "./modules/security"

  name = "${ var.name }"
  network = "${ module.vpc.network }"
  cidr = "${ var.cidr }"
  service_cidr = "${ var.allow_ssh_cidr }"
  allow_ssh_cidr = "${ var.allow_ssh_cidr }"
}

# module "kubeconfig" {
#   source = "../kubeconfig"

#   data_dir = "${ var.data_dir }"
#   endpoint = "${ module.etcd.external_lb }"
#   name = "${ var.name }"
#   ca = "${ module.tls.ca }"
#   client = "${ module.tls.client }"
#   client_key = "${ module.tls.client_key }"
# }

module "tls" {
  source = "../tls"

  data_dir = "${ var.data_dir }"

  tls_ca_cert_subject_common_name = "kubernetes"
  tls_ca_cert_subject_organization = "Kubernetes"
  tls_ca_cert_subject_locality = "San Francisco"
  tls_ca_cert_subject_province = "California"
  tls_ca_cert_subject_country = "US"
  tls_ca_cert_validity_period_hours = 1000
  tls_ca_cert_early_renewal_hours = 100

  tls_client_cert_subject_common_name = "kubecfg"
  tls_client_cert_validity_period_hours = 1000
  tls_client_cert_early_renewal_hours = 100
  tls_client_cert_dns_names = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local"
  tls_client_cert_ip_addresses = "127.0.0.1"

  tls_apiserver_cert_subject_common_name = "kubernetes-master"
  tls_apiserver_cert_validity_period_hours = 1000
  tls_apiserver_cert_early_renewal_hours = 100
  tls_apiserver_cert_dns_names = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local"
  tls_apiserver_cert_ip_addresses = "127.0.0.1,10.0.0.1,${ module.master.external_lb },${ var.internal_lb_ip }"

  tls_worker_cert_subject_common_name = "kubernetes-worker"
  tls_worker_cert_validity_period_hours = 1000
  tls_worker_cert_early_renewal_hours = 100
  tls_worker_cert_dns_names = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local"
  tls_worker_cert_ip_addresses = "127.0.0.1"
}
