module "vpc" {
  source = "./modules/vpc"
  name = "${ var.name }"

  azs = "${ var.aws_azs }"
  cidr = "${ var.vpc_cidr }"
}

module "security" {
  source         = "./modules/security"
  name           = "${ var.name }"

  vpc_cidr       = "${ var.vpc_cidr }"
  vpc_id         = "${ module.vpc.id }"
  allow_ssh_cidr = "${ var.allow_ssh_cidr }"
}


module "iam" {
  source = "./modules/iam"
  name   = "${ var.name }"
}


module "dns" {
  source            = "./modules/dns"
  name              = "${ var.name }"
  master_node_count = "${ var.master_node_count }"
  master_ips        = "${ module.etcd.master_ips }"
  internal_tld      = "${ var.internal_tld }"
  vpc_id            = "${ module.vpc.id }"
}

module "etcd" {
  source                         = "./modules/etcd"
  depends_id                     = "${ module.dns.depends_id }"
  instance_profile_name          = "${ module.iam.instance_profile_name_master }"

  master_node_count              = "${ var.master_node_count }"
  name                           = "${ var.name }"
  ami_id                         = "${ var.aws_image_ami }"
  key_name                       = "${ var.aws_key_name }"
  cluster_domain                 = "${ var.cluster_domain }"
  kubelet_image_url              = "${ var.kubelet_image_url }"
  kubelet_image_tag              = "${ var.kubelet_image_tag }"
  dns_service_ip                 = "${ var.dns_service_ip }"
  etcd_security_group_id         = "${ module.security.etcd_id }"
  external_elb_security_group_id = "${ module.security.external_elb_id }"
  instance_type                  = "${ var.aws_master_vm_size }"
  internal_tld                   = "${ var.internal_tld }"
  pod_cidr                       = "${ var.pod_cidr }"
  region                         = "${ var.aws_region }"
  service_cidr                   = "${ var.service_cidr }"
  subnet_ids_private             = "${ module.vpc.subnet_ids_private }"
  subnet_ids_public              = "${ module.vpc.subnet_ids_public }"
  vpc_id                         = "${ module.vpc.id }"
  ca                             = "${ module.tls.ca }"
  etcd                           = "${ module.tls.etcd }"
  etcd_key                       = "${ module.tls.etcd_key }"
  apiserver                      = "${ module.tls.apiserver }"
  apiserver_key                  = "${ module.tls.apiserver_key }"
}


module "bastion" {
  source = "./modules/bastion"

  ami_id = "${ var.aws_image_ami }"
  instance_type = "${ var.aws_bastion_vm_size }"
  internal_tld = "${ var.internal_tld }"
  key_name = "${ var.aws_key_name }"
  name = "${ var.name }"
  security_group_id = "${ module.security.bastion_id }"
  subnet_ids = "${ module.vpc.subnet_ids_public }"
  vpc_id = "${ module.vpc.id }"
}

module "worker" {
  source = "./modules/worker"
  depends_id = "${ module.dns.depends_id }"
  instance_profile_name = "${ module.iam.instance_profile_name_worker }"

  ami_id = "${ var.aws_image_ami }"
  capacity = {
    desired = "${ var.worker_node_count}"
    max = "${ var.worker_node_max}"
    min = "${ var.worker_node_min}"
  }
  cluster_domain = "${ var.cluster_domain }"
  kubelet_image_url = "${ var.kubelet_image_url }"
  kubelet_image_tag = "${ var.kubelet_image_tag }"
  dns_service_ip = "${ var.dns_service_ip }"
  instance_type = "${ var.aws_worker_vm_size }"
  internal_tld = "${ var.internal_tld }"
  key_name = "${ var.aws_key_name }"
  name = "${ var.name }"
  region = "${ var.aws_region }"
  security_group_id = "${ module.security.worker_id }"
  subnet_ids = "${ module.vpc.subnet_ids_private }"
  ca = "${ module.tls.ca }"
  worker = "${ module.tls.worker }"
  worker_key = "${ module.tls.worker_key }"

  volume_size = {
    ebs = 250
    root = 52
  }
  vpc_id = "${ module.vpc.id }"
  worker_name = "general"
}

module "kubeconfig" {
  source = "../kubeconfig"

  data_dir = "${ var.data_dir }"
  endpoint = "${ module.etcd.external_elb }"
  name = "${ var.name }"
  ca = "${ module.tls.ca}"
  client = "${ module.tls.client }"
  client_key = "${ module.tls.client_key }"
}

module "tls" {
  source = "../tls"

  data_dir = "${ var.data_dir }"

  tls_ca_cert_subject_common_name = "CA"
  tls_ca_cert_subject_organization = "Kubernetes"
  tls_ca_cert_subject_locality = "San Francisco"
  tls_ca_cert_subject_province = "California"
  tls_ca_cert_subject_country = "US"
  tls_ca_cert_validity_period_hours = 1000
  tls_ca_cert_early_renewal_hours = 100

  tls_etcd_cert_subject_common_name = "k8s-etcd"
  tls_etcd_cert_validity_period_hours = 1000
  tls_etcd_cert_early_renewal_hours = 100
  tls_etcd_cert_dns_names = "etcd.${ var.internal_tld },etcd1.${ var.internal_tld },etcd2.${ var.internal_tld },etcd3.${ var.internal_tld }"
  tls_etcd_cert_ip_addresses = "127.0.0.1"

  tls_client_cert_subject_common_name = "k8s-admin"
  tls_client_cert_validity_period_hours = 1000
  tls_client_cert_early_renewal_hours = 100
  tls_client_cert_dns_names = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local,*.*.compute.internal,*.ec2.internal"
  tls_client_cert_ip_addresses = "127.0.0.1"

  tls_apiserver_cert_subject_common_name = "k8s-apiserver"
  tls_apiserver_cert_validity_period_hours = 1000
  tls_apiserver_cert_early_renewal_hours = 100
  tls_apiserver_cert_dns_names = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local,master.${ var.internal_tld },*.ap-southeast-2.elb.amazonaws.com"
  tls_apiserver_cert_ip_addresses = "127.0.0.1,10.0.0.1"

  tls_worker_cert_subject_common_name = "k8s-worker"
  tls_worker_cert_validity_period_hours = 1000
  tls_worker_cert_early_renewal_hours = 100
  tls_worker_cert_dns_names = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local,*.*.compute.internal,*.ec2.internal"
  tls_worker_cert_ip_addresses = "127.0.0.1"
}
