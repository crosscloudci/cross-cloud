module "master" {
  source = "./modules/master"

  name           = "${ var.name }"
  flavor         = "${ var.master_flavor_name }"
  image          = "${ var.master_image_name }"
  count          = "${ var.master_node_count }"
  network_id     = "${ module.network.network_id }"
  cloud_init     = "${ module.master_templates.master_cloud_init }"
  security_group = "${ module.network.security_group_name }"
  keypair        = "${ var.keypair_name }"
}

module "network" {
  source = "./modules/network"

  external_network_id = "${ var.external_network_id }"
  internal_network_cidr = "${ var.internal_network_cidr }"
  floating_ip_pool = "${ var.public_floating_ip_pool }"
}

module "master_templates" {
  source = "/cncf/master_templates-v1.9.0"

  master_node_count = "${ var.master_node_count }"
  name              = "${ var.name }"
  etcd_endpoint     = "${ var.etcd_endpoint }"
  etcd_bootstrap    = ""

  kubelet_artifact              = "${ var.kubelet_artifact }"
  cni_artifact                  = "${ var.cni_artifact }"
  etcd_image                    = "${ var.etcd_image }"
  etcd_tag                      = "${ var.etcd_tag }"
  kube_apiserver_image          = "${ var.kube_apiserver_image }"
  kube_apiserver_tag            = "${ var.kube_apiserver_tag }"
  kube_controller_manager_image = "${ var.kube_controller_manager_image }"
  kube_controller_manager_tag   = "${ var.kube_controller_manager_tag }"
  kube_scheduler_image          = "${ var.kube_scheduler_image }"
  kube_scheduler_tag            = "${ var.kube_scheduler_tag }"
  kube_proxy_image              = "${ var.kube_proxy_image }"
  kube_proxy_tag                = "${ var.kube_proxy_tag }"

  cloud_provider      = "${ var.cloud_provider }"
  cloud_config        = "${ var.cloud_config }"
  cluster_domain      = "${ var.cluster_domain }"
  cluster_name        = "${ var.cluster_name }"
  pod_cidr            = "${ var.pod_cidr }"
  service_cidr        = "${ var.service_cidr }"
  non_masquerade_cidr = "${ var.non_masquerade_cidr }"
  dns_service_ip      = "${ var.dns_service_ip }"

  ca            = "${ module.tls.ca }"
  ca_key        = "${ module.tls.ca_key }"
  apiserver     = "${ module.tls.apiserver }"
  apiserver_key = "${ module.tls.apiserver_key }"

  cloud_config_file = "${ data.template_file.cloud_conf.rendered }"

  dns_master = ""
  dns_conf = ""
}

module "worker" {
  source = "./modules/worker"

  name           = "${ var.name }"
  flavor         = "${ var.worker_flavor_name }"
  image          = "${ var.worker_image_name }"
  count          = "${ var.worker_node_count }"
  network_id     = "${ module.network.network_id }"
  security_group = "${ module.network.security_group_name }"
  cloud_init     = "${ module.worker_templates.worker_cloud_init }"
  keypair        = "${ var.keypair_name }"
}

module "worker_templates" {
  source = "/cncf/worker_templates-v1.9.0"

  worker_node_count = "${ var.worker_node_count }"
  name              = "${ var.name }"

  kubelet_artifact = "${ var.kubelet_artifact }"
  cni_artifact     = "${ var.cni_artifact }"
  kube_proxy_image = "${ var.kube_proxy_image }"
  kube_proxy_tag   = "${ var.kube_proxy_tag }"

  cloud_provider      = "${ var.cloud_provider }"
  cloud_config        = "${ var.cloud_config }"
  cluster_domain      = "${ var.cluster_domain }"
  pod_cidr            = "${ var.pod_cidr }"
  non_masquerade_cidr = "${ var.non_masquerade_cidr }"
  dns_service_ip      = "${ var.dns_service_ip }"
  internal_lb_ip      = "${ module.network.lb_ip }"

  ca         = "${ module.tls.ca }"
  worker     = "${ module.tls.worker }"
  worker_key = "${ module.tls.worker_key }"

  cloud_config_file = "${ data.template_file.cloud_conf.rendered }"

  dns_conf   = ""
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
  tls_apiserver_cert_dns_names = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local,*.${ var.cloud_location }"
  tls_apiserver_cert_ip_addresses = "127.0.0.1,10.0.0.1,100.64.0.1,${ var.dns_service_ip },${ module.network.fip },${ module.network.lb_ip }"

  tls_worker_cert_subject_common_name = "kubernetes-worker"
  tls_worker_cert_validity_period_hours = 1000
  tls_worker_cert_early_renewal_hours = 100
  tls_worker_cert_dns_names = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local"
  tls_worker_cert_ip_addresses = "127.0.0.1"
}

module "kubeconfig" {
  source = "../kubeconfig"

  data_dir = "${ var.data_dir }"
  endpoint = "${ module.network.fip }"
  name = "${ var.name }"
  ca = "${ module.tls.ca }"
  client = "${ module.tls.client }"
  client_key = "${ module.tls.client_key }"
}

module "loadbalancer" {
  source = "./modules/loadbalancer"

  name              = "${ var.name }"
  flavor            = "${ var.lb_flavor_name }"
  image             = "${ var.lb_image_name }"
  network_id        = "${ module.network.network_id }"
  fip               = "${ module.network.fip }"
  lb_port           = "${ module.network.lb_port }"
  master_count      = "${ var.master_node_count }"
  master_ips        = "${ module.master.ips }"
  security_group    = "${ module.network.security_group_name }"
  keypair           = "${ var.keypair_name }"
}
