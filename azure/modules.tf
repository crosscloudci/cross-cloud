module "network" {
  source = "./modules/network"
  name = "${ var.name }"
  vpc_cidr = "${ var.vpc_cidr }"
  subnet_cidr = "${ var.subnet_cidr }"
  # name_servers_file = "${ module.dns.name_servers_file }"
  location = "${ var.location }"
 }

module "etcd" {
  source = "./modules/etcd"
  name = "${ var.name }"
  location = "${ var.location }"
  admin_username = "${ var.admin_username }"
  master_node_count = "${ var.master_node_count }"
  master_vm_size = "${ var.master_vm_size }"
  image_publisher = "${ var.image_publisher }"
  image_offer = "${ var.image_offer }"
  image_sku = "${ var.image_sku }"
  image_version = "${ var.image_version }"
  subnet_id = "${ module.network.subnet_id }"
  storage_account = "${ azurerm_storage_account.cncf.name }"
  storage_primary_endpoint = "${ azurerm_storage_account.cncf.primary_blob_endpoint }"
  storage_container = "${ var.name }"
  # storage_container = "${ azurerm_storage_container.cncf.name }"
  availability_id = "${ azurerm_availability_set.cncf.id }"
  cluster_domain = "${ var.cluster_domain }"
  kubelet_image_url = "${ var.kubelet_image_url }"
  kubelet_image_tag = "${ var.kubelet_image_tag }"
  dns_service_ip = "${ var.dns_service_ip }"
  internal_tld = "${ var.internal_tld }"
  pod_cidr = "${ var.pod_cidr }"
  service_cidr = "${ var.service_cidr }"
  ca                             = "${ module.tls.ca }"
  etcd                           = "${ module.tls.etcd }"
  etcd_key                       = "${ module.tls.etcd_key }"
  apiserver                      = "${ module.tls.apiserver }"
  apiserver_key                  = "${ module.tls.apiserver_key }"
  data_dir = "${ var.data_dir }"
  client_id = "${ var.client_id }"
  client_secret = "${ var.client_secret }"
  tenant_id = "${ var.tenant_id }"
  subscription_id = "${ var.subscription_id}"
}


module "bastion" {
  source = "./modules/bastion"
  name = "${ var.name }"
  location = "${ var.location }"
  bastion_vm_size = "${ var.bastion_vm_size }"
  image_publisher = "${ var.image_publisher }"
  image_offer = "${ var.image_offer }"
  image_sku = "${ var.image_sku }"
  image_version = "${ var.image_version }"
  admin_username = "${ var.admin_username }"
  subnet_id = "${ module.network.subnet_id }"
  storage_primary_endpoint = "${ azurerm_storage_account.cncf.primary_blob_endpoint }"
  storage_container = "${ azurerm_storage_container.cncf.name }"
  availability_id = "${ azurerm_availability_set.cncf.id }"
  internal_tld = "${ var.internal_tld }"
  data_dir = "${ var.data_dir }"
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
  tls_etcd_cert_dns_names = "*.${ module.etcd.dns_suffix }"
  tls_etcd_cert_ip_addresses = "127.0.0.1"

  tls_client_cert_subject_common_name = "k8s-admin"
  tls_client_cert_validity_period_hours = 1000
  tls_client_cert_early_renewal_hours = 100
  tls_client_cert_dns_names = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local,*.${ module.etcd.dns_suffix }"
  tls_client_cert_ip_addresses = "127.0.0.1"

  tls_apiserver_cert_subject_common_name = "k8s-apiserver"
  tls_apiserver_cert_validity_period_hours = 1000
  tls_apiserver_cert_early_renewal_hours = 100
  tls_apiserver_cert_dns_names = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local,*.${ module.etcd.dns_suffix },*.${ var.location }.cloudapp.azure.com"
  tls_apiserver_cert_ip_addresses = "127.0.0.1,10.0.0.1"

  tls_worker_cert_subject_common_name = "kubelet"
  tls_worker_cert_validity_period_hours = 1000
  tls_worker_cert_early_renewal_hours = 100
  tls_worker_cert_dns_names = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local,*.${ module.etcd.dns_suffix }"
  tls_worker_cert_ip_addresses = "127.0.0.1"

}

module "worker" {
  source = "./modules/worker"
  name = "${ var.name }"
  location = "${ var.location }"
  admin_username = "${ var.admin_username }"
  worker_node_count = "${ var.worker_node_count }"
  worker_vm_size = "${ var.worker_vm_size }"
  image_publisher = "${ var.image_publisher }"
  image_offer = "${ var.image_offer }"
  image_sku = "${ var.image_sku }"
  image_version = "${ var.image_version }"
  subnet_id = "${ module.network.subnet_id }"
  storage_account = "${ azurerm_storage_account.cncf.name }"
  storage_primary_endpoint = "${ azurerm_storage_account.cncf.primary_blob_endpoint }"
  storage_container = "${ azurerm_storage_container.cncf.name }"
  availability_id = "${ azurerm_availability_set.cncf.id }"
  external_lb = "${ module.etcd.external_lb }"
  cluster_domain = "${ var.cluster_domain }"
  kubelet_image_url = "${ var.kubelet_image_url }"
  kubelet_image_tag = "${ var.kubelet_image_tag }"
  dns_service_ip = "${ var.dns_service_ip }"
  internal_tld = "${ var.internal_tld }"
  ca                             = "${ module.tls.ca }"
  worker                         = "${ module.tls.worker }"
  worker_key                     = "${ module.tls.worker_key }"
  data_dir = "${ var.data_dir }"
  azure_cloud = "${ module.etcd.azure_cloud }"
  kube_proxy_token = "${ module.etcd.kube_proxy_token }"
  dns_suffix = "${ module.etcd.dns_suffix }"
}


module "kubeconfig" {
  source = "../kubeconfig"

  data_dir = "${ var.data_dir }"
  endpoint = "${ module.etcd.fqdn_lb }"
  name = "${ var.name }"
  ca = "${ module.tls.ca }"
  client = "${ module.tls.client }"
  client_key = "${ module.tls.client_key }"
}
