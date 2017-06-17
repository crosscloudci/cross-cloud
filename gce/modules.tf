module "vpc" {
  source = "./modules/vpc"
  name = "${ var.name }"
  cidr = "${ var.cidr }"
  # name-servers-file = "${ module.dns.name-servers-file }"
  region = "${ var.region }"
 }
# module "dns" {
#   source = "./modules/dns"
#   name = "${ var.name }"
#   internal_tld = "${ var.internal_tld }"
#   # master-ips = "${ module.etcd.master-ips }"
#   master_node_count = "${ var.master_node_count }"
#   name-servers-file = "${ var.name-servers-file }"
# }

module "dns" {
  source = "./modules/dns"
  name = "${ var.name }"
  external_lb = "${ module.etcd.external_lb }"
  internal_lb = "${ module.etcd.internal_lb}"
  master_node_count = "${ var.master_node_count }"
  domain = "${ var.domain }"
}

 module "etcd" {
   source = "./modules/etcd"
   name = "${ var.name }"
   region = "${ var.region }"
   zone = "${ var.zone }"
   project = "${ var.project }"
   network = "${ module.vpc.network }"
   subnetwork = "${ module.vpc.subnetwork }"
   # name-servers-file = "${ var.name-servers-file }"
# admin_username = "${ var.admin_username }"
   master_node_count = "${ var.master_node_count }"
#    master_vm_size = "${ var.master_vm_size }"
#    image-publisher = "${ var.image-publisher }"
#    image-offer = "${ var.image-offer }"
#    image-sku = "${ var.image-sku }"
#    image-version = "${ var.image-version }"
#    subnet-id = "${ module.vpc.subnet-id }"
#    storage-account = "${ azurerm_storage_account.cncf.name }"
#    storage-primary-endpoint = "${ azurerm_storage_account.cncf.primary_blob_endpoint }"
#    storage-container = "${ azurerm_storage_container.cncf.name }"
#    availability-id = "${ azurerm_availability_set.cncf.id }"
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
#    cloud-config = "${file("${ var.data_dir }/azure-config.json")}"
#    # etcd-security-group-id = "${ module.security.etcd-id }"
#    # external-elb-security-group-id = "${ module.security.external-elb-id }"
}


module "bastion" {
  source = "./modules/bastion"
  name = "${ var.name }"
  region = "${ var.region }"
  zone = "${ var.zone }"
  project = "${ var.project }"
  # bastion-vm-size = "${ var.bastion-vm-size }"
  # image-publisher = "${ var.image-publisher }"
  # image-offer = "${ var.image-offer }"
  # image-sku = "${ var.image-sku }"
  # image-version = "${ var.image-version }"
  # admin_username = "${ var.admin_username }"
  # subnet-id = "${ module.vpc.subnet-id }"
  # storage-primary-endpoint = "${ azurerm_storage_account.cncf.primary_blob_endpoint }"
  # storage-container = "${ azurerm_storage_container.cncf.name }"
  # availability-id = "${ azurerm_availability_set.cncf.id }"
  internal_tld = "${ var.internal_tld }"
}

module "worker" {
  source = "./modules/worker"
  name = "${ var.name }"
  region = "${ var.region }"
  zone = "${ var.zone }"
  project = "${ var.project }"
  # admin_username = "${ var.admin_username }"
  worker_node_count = "${ var.worker_node_count }"
  # worker-vm-size = "${ var.worker-vm-size }"
  # image-publisher = "${ var.image-publisher }"
  # image-offer = "${ var.image-offer }"
  # image-sku = "${ var.image-sku }"
  # image-version = "${ var.image-version }"
  # subnet-id = "${ module.vpc.subnet-id }"
  # storage-account = "${ azurerm_storage_account.cncf.name }"
  # storage-primary-endpoint = "${ azurerm_storage_account.cncf.primary_blob_endpoint }"
  # storage-container = "${ azurerm_storage_container.cncf.name }"
  # availability-id = "${ azurerm_availability_set.cncf.id }"
  # external-lb = "${ module.etcd.external-lb }"
  cluster_domain = "${ var.cluster_domain }"
  kubelet_image_url = "${ var.kubelet_image_url }"
  kubelet_image_tag = "${ var.kubelet_image_tag }"
  dns_service_ip = "${ var.dns_service_ip }"
  internal_tld = "${ var.internal_tld }"
  domain = "${ var.domain }"
  ca = "${ module.tls.ca }"
  worker = "${ module.tls.worker }"
  worker_key = "${ module.tls.worker_key }"

  # cloud-config = "${file("${ var.data_dir }/azure-config.json")}"
  # security-group-id = "${ module.security.worker-id }"
}

module "security" {
  source = "./modules/security"

  network = "${ module.vpc.network }"
  # cidr-allow-ssh = "${ var.cidr["allow-ssh"] }"
  # cidr-vpc = "${ var.cidr["vpc"] }"
  name = "${ var.name }"
  # vpc-id = "${ module.vpc.id }"
}

module "kubeconfig" {
  source = "../kubeconfig"

  data_dir = "${ var.data_dir }"
  endpoint = "endpoint.${ var.name }.${ var.domain }"
  name = "${ var.name }"
  ca = "${ module.tls.ca }"
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
  tls_etcd_cert_dns_names = "*.c.${ var.project }.internal,test-master1.c.${ var.project }.internal,test-master2.c.${ var.project }.internal,test-master3.c.${ var.project }.internal"
  tls_etcd_cert_ip_addresses = "127.0.0.1"

  tls_client_cert_subject_common_name = "k8s-admin"
  tls_client_cert_validity_period_hours = 1000
  tls_client_cert_early_renewal_hours = 100
  tls_client_cert_dns_names = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local"
  tls_client_cert_ip_addresses = "127.0.0.1"

  tls_apiserver_cert_subject_common_name = "k8s-apiserver"
  tls_apiserver_cert_validity_period_hours = 1000
  tls_apiserver_cert_early_renewal_hours = 100
  tls_apiserver_cert_dns_names = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local,master.${ var.name }.${ var.domain },endpoint.${ var.name }.${ var.domain }"
  tls_apiserver_cert_ip_addresses = "127.0.0.1,10.0.0.1"

  tls_worker_cert_subject_common_name = "k8s-worker"
  tls_worker_cert_validity_period_hours = 1000
  tls_worker_cert_early_renewal_hours = 100
  tls_worker_cert_dns_names = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local"
  tls_worker_cert_ip_addresses = "127.0.0.1"
}
