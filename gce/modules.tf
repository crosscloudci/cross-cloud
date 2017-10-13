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
   master_cloud_init = "${ module.master_templates.master_cloud_init }"
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

module "kubeconfig" {
  source = "../kubeconfig"

  data_dir = "${ var.data_dir }"
  endpoint = "${ module.master.external_lb }"
  name = "${ var.name }"
  ca = "${ module.tls.ca }"
  client = "${ module.tls.client }"
  client_key = "${ module.tls.client_key }"
}

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
  tls_apiserver_cert_ip_addresses = "127.0.0.1,100.64.0.1,${ var.dns_service_ip },${ module.master.external_lb },${ var.internal_lb_ip }"

  tls_worker_cert_subject_common_name = "kubernetes-worker"
  tls_worker_cert_validity_period_hours = 1000
  tls_worker_cert_early_renewal_hours = 100
  tls_worker_cert_dns_names = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local"
  tls_worker_cert_ip_addresses = "127.0.0.1"
}

module "master_templates" {
  source = "../master_templates"

  master_node_count = "${ var.master_node_count }"
  name = "${ var.name }"
  dns_suffix = "c.${ var.project }.internal"
  hostname_suffix = "${ var.name }-master"

  kubelet_artifact = "${ var.kubelet_artifact }"
  cni_artifact = "${ var.cni_artifact }"
  etcd_registry = "${ var.etcd_registry }"
  etcd_tag = "${ var.etcd_tag }"
  kube_apiserver_registry = "${ var.kube_apiserver_registry }"
  kube_apiserver_tag = "${ var.kube_apiserver_tag }"
  kube_controller_manager_registry = "${ var.kube_controller_manager_registry }"
  kube_controller_manager_tag = "${ var.kube_controller_manager_tag }"
  kube_scheduler_registry = "${ var.kube_scheduler_registry }"
  kube_scheduler_tag = "${ var.kube_scheduler_tag }"
  kube_proxy_registry = "${ var.kube_proxy_registry }"
  kube_proxy_tag = "${ var.kube_proxy_tag }"

  cloud_provider = "${ var.cloud_provider }"
  cloud_config = "${ var.cloud_config }"
  cluster_domain = "${ var.cluster_domain }"
  pod_cidr = "${ var.pod_cidr }"
  service_cidr = "${ var.service_cidr }"
  non_masquerade_cidr = "${ var.non_masquerade_cidr }"
  dns_service_ip = "${ var.dns_service_ip }"

  ca = "${ module.tls.ca }"
  ca_key = "${ module.tls.ca_key }"
  apiserver = "${ module.tls.apiserver }"
  apiserver_key = "${ module.tls.apiserver_key }"
  cloud_config_file = ""

}

module "worker_templates" {
  source = "../worker_templates"

  worker_node_count = "${ var.worker_node_count }"
  name = "${ var.name }"
  hostname_suffix = "$private_ipv4"

  kubelet_artifact = "${ var.kubelet_artifact }"
  cni_artifact = "${ var.cni_artifact }"
  kube_proxy_registry = "${ var.kube_proxy_registry }"
  kube_proxy_tag = "${ var.kube_proxy_tag }"

  cloud_provider = "${ var.cloud_provider }"
  cloud_config = "${ var.cloud_config }"
  cluster_domain = "${ var.cluster_domain }"
  pod_cidr = "${ var.pod_cidr }"
  non_masquerade_cidr = "${ var.non_masquerade_cidr }"
  dns_service_ip = "${ var.dns_service_ip }"
  internal_lb_ip = "${ var.internal_lb_ip }"

  ca = "${ module.tls.ca }"
  worker = "${ module.tls.worker }"
  worker_key = "${ module.tls.worker_key }"
  cloud_config_file = ""

}
