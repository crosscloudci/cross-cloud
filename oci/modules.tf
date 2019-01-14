module "compartment" {
  source                                        = "./modules/compartment"

  compartment_id                                = "${var.oci_tenancy_ocid}"
  label_prefix                                  = "${var.label_prefix}"
}

module "ssh" {
  source                                        = "./modules/ssh"

  ssh_private_key                               = "${var.ssh_private_key}"
  ssh_public_key                                = "${var.ssh_public_key}"
  data_dir                                      = "${var.data_dir}"
}

module "network" {
  source                                        = "./modules/network"

  network_cidrs                                 = "${var.network_cidrs}"
  compartment_id                                = "${module.compartment.compartment_id}"
  label_prefix                                  = "${var.name}"
  tenancy_id                                    = "${var.oci_tenancy_ocid}"
  ssh_public_key                                = "${module.ssh.ssh_public_key}"
}

module "master" {
  source                                        = "./modules/master"

  count                                         = "${var.master_node_count}"
  availability_domain                           = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
  compartment_id                                = "${module.compartment.compartment_id}"
  hostname                                      = "${var.name}-master"
  hostname_suffix                               = "${var.name}.${var.cloud_provider}.local"
  hostname_path                                 = "/etc/hostname"
  master_cloud_init                             = "${module.master_templates.master_cloud_init}"
  image_id                                      = "${var.master_image_id}"
  shape                                         = "${var.master_shape}"
  subnet_id                                     = "${module.network.k8s_subnet_ad1_id}"
  ssh_public_key                                = "${module.ssh.ssh_public_key}"
  ssh_private_key                               = "${module.ssh.ssh_private_key}"
  coreos_image_ocid                             = "${var.coreos_image_ocid}"
}

module "worker" {
  source                                        = "./modules/worker"

  count                                         = "${var.worker_node_count}"
  availability_domain                           = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
  compartment_id                                = "${module.compartment.compartment_id}"
  hostname                                      = "${var.name}-worker"
  hostname_suffix                               = "${var.name}.${var.cloud_provider}.local"
  hostname_path                                 = "/etc/hostname"
  worker_cloud_init                             = "${module.worker_templates.worker_cloud_init}"
  image_id                                      = "${var.worker_image_id}"
  shape                                         = "${var.worker_shape}"
  subnet_id                                     = "${module.network.k8s_subnet_ad1_id}"
  ssh_public_key                                = "${module.ssh.ssh_public_key}"
  ssh_private_key                              = "${module.ssh.ssh_private_key}"
  coreos_image_ocid                             = "${var.coreos_image_ocid}"
}

module "master_templates" {
  source                                        = "./modules/master_templates-v1.10.0-oci"

  hostname                                      = ""
  hostname_suffix                               = ""
  hostname_path                                 = "/etc/ignore_hostname"
  master_node_count                             = "${var.master_node_count}"
  kube_controller_manager_artifact              = "${var.kube_controller_manager_artifact}"
  ca_key                                        = "${module.tls.ca_key}"
  cloud_provider                                = ""
  cluster_domain                                = "${var.cluster_domain}"
  dns_service_ip                                = "${var.dns_service_ip}"
  kube_scheduler_artifact                       = "${var.kube_scheduler_artifact}"
  apiserver_key                                 = "${module.tls.apiserver_key}"
  kube_apiserver_artifact                       = "${var.kube_apiserver_artifact}"
  kubelet_artifact                              = "${var.kubelet_artifact}"
  kube_proxy_image                              = "${var.kube_proxy_image}"
  kube_proxy_tag                                = "${var.kube_proxy_tag}"
  cloud_config                                  = "${var.cloud_config}"
  apiserver                                     = "${module.tls.apiserver}"
  dns_conf                                      = "${module.dns.dns_conf}"
  service_cidr                                  = "${var.service_cidr}"
  scheduler_key                                 = "${module.tls.scheduler_key}"
  name                                          = "${var.name}"
  dns_dhcp                                      = "${module.dns.dns_dhcp}"
  cni_artifact                                  = "${var.cni_artifact}"
  cni_plugins_artifact                          = "${var.cni_plugins_artifact}"
  ca                                            = "${module.tls.ca}"
  etcd_endpoint                                 = "${var.etcd_endpoint}"
  etcd_artifact                                 = "${var.etcd_artifact}"
  pod_cidr                                      = "${var.pod_cidr}"
  controller_key                                = "${module.tls.controller_key}"
  controller                                    = "${module.tls.controller}"
  scheduler                                     = "${module.tls.scheduler}"
  cloud_config_file                             = ""
  etcd_discovery                                = "${var.name}.${var.cloud_provider}.local"
  proxy                                         = "${module.tls.proxy}"
  proxy_key                                     = "${module.tls.proxy_key}"
  bootstrap                                     = "${module.master_templates.bootstrap}"
  non_masquerade_cidr                           = "${var.non_masquerade_cidr}"
  internal_lb_ip                                = "internal-master.${var.name}.${var.cloud_provider}.local"
}

module "worker_templates" {
  source                                        = "./modules/worker_templates-v1.10.0-oci"

  hostname                                      = ""
  hostname_suffix                               = ""
  hostname_path                                 = "/etc/ignore_hostname"
  worker_node_count                             = "${var.worker_node_count}"
  kubelet_artifact                              = "${var.kubelet_artifact}"
  cni_artifact                                  = "${var.cni_artifact}"
  cni_plugins_artifact                          = "${var.cni_plugins_artifact}"
  kube_proxy_image                              = "${var.kube_proxy_image}"
  kube_proxy_tag                                = "${var.kube_proxy_tag}"
  cloud_provider                                = "${var.kubelet_cloud_provider}"
  cloud_config                                  = "${var.cloud_config}"
  cluster_domain                                = "${var.cluster_domain}"
  pod_cidr                                      = "${var.pod_cidr}"
  non_masquerade_cidr                           = "${var.non_masquerade_cidr}"
  dns_service_ip                                = "${var.dns_service_ip}"
  internal_lb_ip                                = "internal-master.${var.name}.${var.cloud_provider}.local"
  ca                                            = "${module.tls.ca}"
  kubelet                                       = "${module.tls.kubelet}"
  kubelet_key                                   = "${module.tls.kubelet_key}"
  proxy                                         = "${module.tls.proxy}"
  proxy_key                                     = "${module.tls.proxy_key}"
  bootstrap                                     = "${module.master_templates.bootstrap}"
  cloud_config_file                             = ""
  dns_conf                                      = "${module.dns.dns_conf}"
  dns_dhcp                                      = ""
}

module "master_lb" {
  source                                        = "./modules/loadbalancer"

  compartment_id                                = "${module.compartment.compartment_id}"
  is_private                                    = "false"
  lb_subnet_0_id                                = "${module.network.lb_subnet_ad1_id}"
  lb_subnet_1_id                                = "${module.network.lb_subnet_ad2_id}"
  k8smaster_ad1_private_ips                     = "${module.master.private_master_ips}"
  k8sMasterAd1Count                             = "${var.master_node_count}"
  label_prefix                                  = "${var.name}"
  shape                                         = "${var.master_lb_shape}"
}

module "addons" {
  source                                        = "./modules/addons"

  oci_region                                    = "${var.oci_region}"
  oci_tenancy_ocid                              = "${var.oci_tenancy_ocid}"
  oci_user_ocid                                 = "${var.oci_user_ocid}"
  oci_fingerprint                               = "${var.oci_fingerprint}"
  oci_compartment_ocid                          = "${module.compartment.compartment_id}"
  oci_vcn_ocid                                  = "${module.network.oci_core_vcn_id}"
  oci_lb_subnet_1_ocid                          = "${module.network.k8s_subnet_ad1_id}"
  oci_lb_subnet_2_ocid                          = "${module.network.k8s_subnet_ad2_id}"
}

module "dns" {
  source                                        = "../dns-etcd"

  name                                          = "${var.name}"
  etcd_server                                   = "${var.etcd_server}"
  discovery_nameserver                          = "${var.discovery_nameserver}"
  upstream_dns                                  = "DNS=8.8.8.8"
  cloud_provider                                = "${var.cloud_provider}"
  master_ips                                    = "${module.master.private_master_ips_string}"
  public_master_ips                             = "${module.master_lb.ip_addresses}"
  worker_ips                                    = "${module.worker.worker_ips}"
  master_node_count                             = "${var.master_node_count}"
  worker_node_count                             = "${var.worker_node_count}"
}

module "kubeconfig" {
  source                                        = "../kubeconfig"

  data_dir                                      = "${var.data_dir}"
  endpoint                                      = "${module.master_lb.ip_addresses}"
  name                                          = "${var.name}"
  ca                                            = "${module.tls.ca}"
  client                                        = "${module.tls.admin}"
  client_key                                    = "${module.tls.admin_key}"
}

module "tls" {
  source                                        = "../tls"

  tls_ca_cert_subject_common_name               = "kubernetes"
  tls_ca_cert_subject_locality                  = "San Francisco"
  tls_ca_cert_subject_organization              = "Kubernetes"
  tls_ca_cert_subject_organization_unit         = "Kubernetes"
  tls_ca_cert_subject_province                  = "California"
  tls_ca_cert_subject_country                   = "US"
  tls_ca_cert_validity_period_hours             = 1000
  tls_ca_cert_early_renewal_hours               = 100

  tls_admin_cert_subject_common_name            = "admin"
  tls_admin_cert_subject_locality               = "San Francisco"
  tls_admin_cert_subject_organization           = "system:masters"
  tls_admin_cert_subject_organization_unit      = "Kubernetes"
  tls_admin_cert_subject_province               = "Callifornia"
  tls_admin_cert_subject_country                = "US"
  tls_admin_cert_validity_period_hours          = 1000
  tls_admin_cert_early_renewal_hours            = 100
  tls_admin_cert_ip_addresses                   = "127.0.0.1"
  tls_admin_cert_dns_names                      = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local"

  tls_apiserver_cert_subject_common_name        = "kubernetes"
  tls_apiserver_cert_subject_locality           = "San Francisco"
  tls_apiserver_cert_subject_organization       = "Kubernetes"
  tls_apiserver_cert_subject_organization_unit  = "Kubernetes"
  tls_apiserver_cert_subject_province           = "California"
  tls_apiserver_cert_subject_country            = "US"
  tls_apiserver_cert_validity_period_hours      = "1000"
  tls_apiserver_cert_early_renewal_hours        = "100"
  tls_apiserver_cert_ip_addresses               = "127.0.0.1,100.64.0.1,${var.dns_service_ip},${module.master_lb.ip_addresses}"
  tls_apiserver_cert_dns_names                  = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local,*.${var.name}.${var.cloud_provider}.local"

  tls_controller_cert_subject_common_name       = "system:kube-controller-manager"
  tls_controller_cert_subject_locality          = "San Francisco"
  tls_controller_cert_subject_organization      = "system:kube-controller-manager"
  tls_controller_cert_subject_organization_unit = "Kubernetes"
  tls_controller_cert_subject_province          = "California"
  tls_controller_cert_subject_country           = "US"
  tls_controller_cert_validity_period_hours     = "1000"
  tls_controller_cert_early_renewal_hours       = "100"
  tls_controller_cert_ip_addresses              = "127.0.0.1"
  tls_controller_cert_dns_names                 = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local"

  tls_scheduler_cert_subject_common_name        = "system:kube-scheduler"
  tls_scheduler_cert_subject_locality           = "San Francisco"
  tls_scheduler_cert_subject_organization       = "system:kube-scheduler"
  tls_scheduler_cert_subject_organization_unit  = "Kubernetes"
  tls_scheduler_cert_subject_province           = "California"
  tls_scheduler_cert_subject_country            = "US"
  tls_scheduler_cert_validity_period_hours      = "1000"
  tls_scheduler_cert_early_renewal_hours        = "100"
  tls_scheduler_cert_ip_addresses               = "127.0.0.1"
  tls_scheduler_cert_dns_names                  = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local"

  tls_kubelet_cert_subject_common_name          = "kubernetes"
  tls_kubelet_cert_subject_locality             = "San Francisco"
  tls_kubelet_cert_subject_organization         = "Kubernetes"
  tls_kubelet_cert_subject_organization_unit    = "Kubernetes"
  tls_kubelet_cert_subject_province             = "California"
  tls_kubelet_cert_subject_country              = "US"
  tls_kubelet_cert_validity_period_hours        = "1000"
  tls_kubelet_cert_early_renewal_hours          = "100"
  tls_kubelet_cert_ip_addresses                 = "127.0.0.1"
  tls_kubelet_cert_dns_names                    = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local,*.${var.name}.${var.cloud_provider}.local"

  tls_proxy_cert_subject_common_name            = "system:kube-proxy"
  tls_proxy_cert_subject_locality               = "San Francisco"
  tls_proxy_cert_subject_organization           = "system:node-proxier"
  tls_proxy_cert_subject_organization_unit      = "Kubernetes"
  tls_proxy_cert_subject_province               = "California"
  tls_proxy_cert_subject_country                = "US"
  tls_proxy_cert_validity_period_hours          = "1000"
  tls_proxy_cert_early_renewal_hours            = "100"
  tls_proxy_cert_ip_addresses                   = "127.0.0.1"
  tls_proxy_cert_dns_names                      = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local"
}
