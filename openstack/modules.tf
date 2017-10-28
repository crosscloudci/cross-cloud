module "network" {
  source = "./modules/network"

  public_network = "${ var.public_network }"
  private_network_cidr = "${ var.private_network_cidr }"
  private_lb_ip        = "${ var.private_lb_ip }"
}

module "master" {
  source = "./modules/master"

  name = "${ var.name }"
  master_flavor_name = "${ var.master_flavor_name }"
  master_image_name = "${ var.master_image_name }"
  master_count = "${ var.master_count }"

  private_network_id = "${ module.network.private_network_id }"

}

module "node" {
  source = "./modules/node"

  name = "${ var.name }"
  node_flavor_name = "${ var.node_flavor_name }"
  node_image_name = "${ var.node_image_name }"
  node_count = "${ var.node_count }"
  
  private_network_id = "${ module.network.private_network_id }"
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
