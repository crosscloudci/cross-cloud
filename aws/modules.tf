module "vpc" {
  source = "./modules/vpc"
  name = "${ var.name }"

  aws_availability_zone = "${ var.aws_availability_zone }"
  subnet_cidr = "${ var.subnet_cidr }"
  cidr = "${ var.vpc_cidr }"
}

module "security" {
  source         = "./modules/security"
  name           = "${ var.name }"

  vpc_cidr       = "${ var.vpc_cidr }"
  vpc_id         = "${ module.vpc.vpc_id }"
  allow_ssh_cidr = "${ var.allow_ssh_cidr }"
}


module "iam" {
  source = "./modules/iam"
  name   = "${ var.name }"
}


module "master" {
  source                         = "./modules/master"
  instance_profile_name          = "${ module.iam.instance_profile_name_master }"

  master_node_count              = "${ var.master_node_count }"
  name                           = "${ var.name }"
  ami_id                         = "${ var.aws_image_ami }"
  key_name                       = "${ var.aws_key_name }"
  master_security                = "${ module.security.master_id }"
  external_lb_security           = "${ module.security.external_lb_id }"
  internal_lb_security           = "${ module.security.internal_lb_id }"
  instance_type                  = "${ var.aws_master_vm_size }"
  region                         = "${ var.aws_region }"
  subnet_prefix                  = "${ var.subnet_prefix }"
  subnet_id                      = "${ module.vpc.subnet_id }"
  vpc_id                         = "${ module.vpc.vpc_id }"
}


module "bastion" {
  source = "./modules/bastion"

  ami_id = "${ var.aws_image_ami }"
  instance_type = "${ var.aws_bastion_vm_size }"
  internal_tld = "${ var.internal_tld }"
  key_name = "${ var.aws_key_name }"
  name = "${ var.name }"
  security_group_id = "${ module.security.bastion_id }"
  subnet_id = "${ module.vpc.subnet_id }"
  vpc_id = "${ module.vpc.vpc_id }"
}

# module "worker" {
#   source = "./modules/worker"
#   depends_id = "${ module.dns.depends_id }"
#   instance_profile_name = "${ module.iam.instance_profile_name_worker }"

#   ami_id = "${ var.aws_image_ami }"
#   capacity = {
#     desired = "${ var.worker_node_count}"
#     max = "${ var.worker_node_max}"
#     min = "${ var.worker_node_min}"
#   }
#   cluster_domain = "${ var.cluster_domain }"
#   kubelet_image_url = "${ var.kubelet_image_url }"
#   kubelet_image_tag = "${ var.kubelet_image_tag }"
#   dns_service_ip = "${ var.dns_service_ip }"
#   instance_type = "${ var.aws_worker_vm_size }"
#   internal_tld = "${ var.internal_tld }"
#   key_name = "${ var.aws_key_name }"
#   name = "${ var.name }"
#   region = "${ var.aws_region }"
#   security_group_id = "${ module.security.worker_id }"
#   subnet_ids = "${ module.vpc.subnet_ids_private }"
#   ca = "${ module.tls.ca }"
#   worker = "${ module.tls.worker }"
#   worker_key = "${ module.tls.worker_key }"
#   apiserver                      = "${ module.tls.apiserver }"
#   apiserver_key                  = "${ module.tls.apiserver_key }"

#   volume_size = {
#     ebs = 250
#     root = 52
#   }
#   vpc_id = "${ module.vpc.id }"
#   worker_name = "general"
# }

# module "kubeconfig" {
#   source = "../kubeconfig"

#   data_dir = "${ var.data_dir }"
#   endpoint = "${ module.master.external_elb }"
#   name = "${ var.name }"
#   ca = "${ module.tls.ca}"
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
  tls_client_cert_dns_names = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local,*.*.compute.internal,*.ec2.internal"
  tls_client_cert_ip_addresses = "127.0.0.1"

  tls_apiserver_cert_subject_common_name = "kubernetes-master"
  tls_apiserver_cert_validity_period_hours = 1000
  tls_apiserver_cert_early_renewal_hours = 100
  tls_apiserver_cert_dns_names = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local,master.${ var.internal_tld },*.ap-southeast-2.elb.amazonaws.com"
  tls_apiserver_cert_ip_addresses = "127.0.0.1,10.0.0.1"

  tls_worker_cert_subject_common_name = "kubernetes-worker"
  tls_worker_cert_validity_period_hours = 1000
  tls_worker_cert_early_renewal_hours = 100
  tls_worker_cert_dns_names = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local,*.*.compute.internal,*.ec2.internal"
  tls_worker_cert_ip_addresses = "127.0.0.1"

}

module "master_templates" {
  source = "../master_templates"

  master_node_count = "${ var.master_node_count }"
  name = "${ var.name }"
  dns_suffix = "${ var.aws_region }.compute.internal"
  hostname_suffix = "${ replace("${ var.subnet_prefix }", ".", "-") }"

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

