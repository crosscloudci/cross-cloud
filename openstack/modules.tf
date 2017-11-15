module "network" {
  source = "./modules/network"

  public_network = "${ var.public_network }"
  private_network_cidr = "${ var.private_network_cidr }"
  private_lb_ip        = "${ var.private_lb_ip }"
}

module "bastion" {
  source = "./modules/bastion"
  public_network = "${ var.public_network }"
  private_network_id = "${ module.network.private_network_id }"
}

module "master" {
  source = "./modules/master"

  name = "${ var.name }"
  master_flavor_name = "${ var.master_flavor_name }"
  master_image_name = "${ var.master_image_name }"
  master_count = "${ var.master_count }"

  private_network_id = "${ module.network.private_network_id }"
}

module "master_templates" {
  source = "/cncf/master_templates-v1.8.1"

  master_node_count = "${ var.master_count }"
  name = "${ var.name }"
  etcd_endpoint = "${ var.etcd_endpoint }"

  kubelet_artifact = "${ var.kubelet_artifact }"
  cni_artifact = "${ var.cni_artifact }"
  etcd_image = "${ var.etcd_image }"
  etcd_tag = "${ var.etcd_tag }"
  kube_apiserver_image = "${ var.kube_apiserver_image }"
  kube_apiserver_tag = "${ var.kube_apiserver_tag }"
  kube_controller_manager_image = "${ var.kube_controller_manager_image }"
  kube_controller_manager_tag = "${ var.kube_controller_manager_tag }"
  kube_scheduler_image = "${ var.kube_scheduler_image }"
  kube_scheduler_tag = "${ var.kube_scheduler_tag }"
  kube_proxy_image = "${ var.kube_proxy_image }"
  kube_proxy_tag = "${ var.kube_proxy_tag }"

  cloud_provider = "${ var.cloud_provider }"
  cloud_config = "${ var.cloud_config }"
  cluster_domain = "${ var.cluster_domain }"
  cluster_name = "${ var.cluster_name }"
  pod_cidr = "${ var.pod_cidr }"
  service_cidr = "${ var.service_cidr }"
  non_masquerade_cidr = "${ var.non_masquerade_cidr }"
  dns_service_ip = "${ var.dns_service_ip }"

  ca = "${ module.tls.ca }"
  ca_key = "${ module.tls.ca_key }"
  apiserver = "${ module.tls.apiserver }"
  apiserver_key = "${ module.tls.apiserver_key }"
  cloud_config_file = ""

  dns_master = ""
  dns_conf = ""
  corefile = ""
}

module "node" {
  source = "./modules/node"

  name = "${ var.name }"
  node_flavor_name = "${ var.node_flavor_name }"
  node_image_name = "${ var.node_image_name }"
  node_count = "${ var.node_count }"
  
  private_network_id = "${ module.network.private_network_id }"
}

module "worker_templates" {
  source = "/cncf/worker_templates-v1.8.1"

  worker_node_count = "${ var.node_count }"
  name = "${ var.name }"

  kubelet_artifact = "${ var.kubelet_artifact }"
  cni_artifact = "${ var.cni_artifact }"
  kube_proxy_image = "${ var.kube_proxy_image }"
  kube_proxy_tag = "${ var.kube_proxy_tag }"

  cloud_provider = "${ var.cloud_provider }"
  cloud_config = "${ var.cloud_config }"
  cluster_domain = "${ var.cluster_domain }"
  pod_cidr = "${ var.pod_cidr }"
  non_masquerade_cidr = "${ var.non_masquerade_cidr }"
  dns_service_ip = "${ var.dns_service_ip }"
  internal_lb_ip = "${ var.private_lb_ip }"

  ca = "${ module.tls.ca }"
  worker = "${ module.tls.worker }"
  worker_key = "${ module.tls.worker_key }"
  cloud_config_file = ""

  dns_worker = ""
  dns_conf = ""
  corefile = ""
  dns_etcd = ""
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
# TODO determine proper cert settings here
  tls_apiserver_cert_dns_names = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local,*.${ var.cloud_location }"
  tls_apiserver_cert_ip_addresses = "127.0.0.1,10.0.0.1,100.64.0.1,${ var.private_lb_ip }"

  tls_worker_cert_subject_common_name = "kubernetes-worker"
  tls_worker_cert_validity_period_hours = 1000
  tls_worker_cert_early_renewal_hours = 100
  tls_worker_cert_dns_names = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local"
  tls_worker_cert_ip_addresses = "127.0.0.1"
}
