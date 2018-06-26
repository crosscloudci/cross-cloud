module "folder" {
  source = "./modules/folder"

  datacenter  = "${var.datacenter}"
  folder_path = "Workloads/CNCF Cross-Cloud/${var.name}"
}

module "resource_pool" {
  source = "./modules/resource_pool"

  name = "${var.name}"

  datacenter    = "${var.datacenter}"
  resource_pool = "${var.resource_pool}"

  cpu_limit    = "${var.resource_pool_cpu_limit}"
  memory_limit = "${var.resource_pool_memory_limit}"
}

module "master" {
  source = "./modules/master"

  name                 = "${var.name}"
  count                = "${var.master_node_count}"
  cloud_init           = "${module.master_templates.master_cloud_init}"
  num_cpu              = "${var.master_num_cpu}"
  num_cores_per_socket = "${var.master_num_cores_per_socket}"
  memory               = "${var.master_memory}"

  datacenter     = "${var.datacenter}"
  resource_pool  = "${module.resource_pool.id}"
  datastore_name = "${var.datastore_name}"
  folder_path    = "${module.folder.path}"
  network_name   = "${var.master_network_name}"
  template_name  = "${var.master_template_name}"
}

module "master_templates" {
  source = "../master_templates-v1.10.0"

  hostname        = "${var.name}-master"
  hostname_suffix = "${var.name}.${var.cloud_provider}.local"
  hostname_path   = "/etc/hostname"

  master_node_count = "${var.master_node_count}"
  name              = "${var.name}"
  etcd_endpoint     = "etcd.${var.name}.${var.cloud_provider}.local"
  etcd_discovery    = "${var.name}.${var.cloud_provider}.local"

  etcd_artifact                    = "${var.etcd_artifact}"
  kube_apiserver_artifact          = "${var.kube_apiserver_artifact}"
  kube_controller_manager_artifact = "${var.kube_controller_manager_artifact}"
  kube_scheduler_artifact          = "${var.kube_scheduler_artifact}"

  cloud_provider = "${var.cloud_provider}"
  cloud_config   = "${var.cloud_config}"
  cluster_domain = "${var.cluster_domain}"
  pod_cidr       = "${var.pod_cidr}"
  service_cidr   = "${var.service_cidr}"
  dns_service_ip = "${var.dns_service_ip}"

  ca                = "${module.tls.ca}"
  ca_key            = "${module.tls.ca_key}"
  apiserver         = "${module.tls.apiserver}"
  apiserver_key     = "${module.tls.apiserver_key}"
  controller        = "${module.tls.controller}"
  controller_key    = "${module.tls.controller_key}"
  scheduler         = "${module.tls.scheduler}"
  scheduler_key     = "${module.tls.scheduler_key}"
  cloud_config_file = "${data.template_file.cloud_conf.rendered}"

  dns_conf = "${module.dns.dns_conf}"
  dns_dhcp = ""
}

module "worker" {
  source = "./modules/worker"

  name                 = "${var.name}"
  count                = "${var.worker_node_count}"
  cloud_init           = "${module.worker_templates.worker_cloud_init}"
  num_cpu              = "${var.worker_num_cpu}"
  num_cores_per_socket = "${var.worker_num_cores_per_socket}"
  memory               = "${var.worker_memory}"

  datacenter     = "${var.datacenter}"
  resource_pool  = "${module.resource_pool.id}"
  datastore_name = "${var.datastore_name}"
  folder_path    = "${module.folder.path}"
  network_name   = "${var.worker_network_name}"
  template_name  = "${var.worker_template_name}"
}

module "worker_templates" {
  source = "../worker_templates-v1.10.0"

  hostname        = "${var.name}-worker"
  hostname_suffix = "${var.name}.${var.cloud_provider}.local"
  hostname_path   = "/etc/hostname"

  worker_node_count = "${var.worker_node_count}"

  kubelet_artifact     = "${var.kubelet_artifact}"
  cni_artifact         = "${var.cni_artifact}"
  cni_plugins_artifact = "${var.cni_plugins_artifact}"
  kube_proxy_image     = "${var.kube_proxy_image}"
  kube_proxy_tag       = "${var.kube_proxy_tag}"

  cloud_provider      = "${var.cloud_provider}"
  cloud_config        = "${var.cloud_config}"
  cluster_domain      = "${var.cluster_domain}"
  pod_cidr            = "${var.pod_cidr}"
  non_masquerade_cidr = "${var.non_masquerade_cidr}"
  dns_service_ip      = "${var.dns_service_ip}"
  internal_lb_ip      = "internal-master.${var.name}.${var.cloud_provider}.local"

  ca                = "${module.tls.ca}"
  kubelet           = "${module.tls.kubelet}"
  kubelet_key       = "${module.tls.kubelet_key}"
  proxy             = "${module.tls.proxy}"
  proxy_key         = "${module.tls.proxy_key}"
  bootstrap         = "${module.master_templates.bootstrap}"
  cloud_config_file = "${data.template_file.cloud_conf.rendered}"

  dns_conf = "${module.dns.dns_conf}"
  dns_dhcp = ""
}

module "load_balancer" {
  source = "./modules/load_balancer"

  count = "${var.master_node_count}"
  name  = "${var.name}"

  port        = "${var.lb_port}"
  subnet_id   = "${var.lb_subnet_id}"
  target_ips  = ["${split(",", module.master.master_ips)}"]
  target_port = "${var.lb_target_port}"
  vpc_id      = "${var.lb_vpc_id}"

  vsphere_aws_access_key_id     = "${var.vsphere_aws_access_key_id}"
  vsphere_aws_secret_access_key = "${var.vsphere_aws_secret_access_key}"
  vsphere_aws_region            = "${var.vsphere_aws_region}"
}

module "dns" {
  source = "../dns-etcd"

  name                 = "${var.name}"
  etcd_server          = "${var.etcd_server}"
  discovery_nameserver = "${var.discovery_nameserver}"
  upstream_dns         = "DNS=8.8.8.8"
  cloud_provider       = "${var.cloud_provider}"

  master_ips        = "${module.master.master_ips}"
  public_master_ips = "${module.load_balancer.public_address}"
  worker_ips        = "${module.worker.worker_ips}"

  master_node_count = "${var.master_node_count}"
  worker_node_count = "${var.worker_node_count}"
}

module "tls" {
  source = "../tls"

  tls_ca_cert_subject_common_name       = "kubernetes"
  tls_ca_cert_subject_locality          = "San Francisco"
  tls_ca_cert_subject_organization      = "Kubernetes"
  tls_ca_cert_subject_organization_unit = "Kubernetes"
  tls_ca_cert_subject_province          = "California"
  tls_ca_cert_subject_country           = "US"
  tls_ca_cert_validity_period_hours     = 1000
  tls_ca_cert_early_renewal_hours       = 100

  tls_admin_cert_subject_common_name       = "admin"
  tls_admin_cert_subject_locality          = "San Francisco"
  tls_admin_cert_subject_organization      = "system:masters"
  tls_admin_cert_subject_organization_unit = "Kubernetes"
  tls_admin_cert_subject_province          = "Callifornia"
  tls_admin_cert_subject_country           = "US"
  tls_admin_cert_validity_period_hours     = 1000
  tls_admin_cert_early_renewal_hours       = 100
  tls_admin_cert_ip_addresses              = "127.0.0.1"
  tls_admin_cert_dns_names                 = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local"

  tls_apiserver_cert_subject_common_name       = "kubernetes"
  tls_apiserver_cert_subject_locality          = "San Francisco"
  tls_apiserver_cert_subject_organization      = "Kubernetes"
  tls_apiserver_cert_subject_organization_unit = "Kubernetes"
  tls_apiserver_cert_subject_province          = "California"
  tls_apiserver_cert_subject_country           = "US"
  tls_apiserver_cert_validity_period_hours     = "1000"
  tls_apiserver_cert_early_renewal_hours       = "100"
  tls_apiserver_cert_ip_addresses              = "127.0.0.1,100.64.0.1,${var.dns_service_ip}"
  tls_apiserver_cert_dns_names                 = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local,*.${var.name}.${var.cloud_provider}.local"

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

  tls_scheduler_cert_subject_common_name       = "system:kube-scheduler"
  tls_scheduler_cert_subject_locality          = "San Francisco"
  tls_scheduler_cert_subject_organization      = "system:kube-scheduler"
  tls_scheduler_cert_subject_organization_unit = "Kubernetes"
  tls_scheduler_cert_subject_province          = "California"
  tls_scheduler_cert_subject_country           = "US"
  tls_scheduler_cert_validity_period_hours     = "1000"
  tls_scheduler_cert_early_renewal_hours       = "100"
  tls_scheduler_cert_ip_addresses              = "127.0.0.1"
  tls_scheduler_cert_dns_names                 = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local"

  tls_kubelet_cert_subject_common_name       = "kubernetes"
  tls_kubelet_cert_subject_locality          = "San Francisco"
  tls_kubelet_cert_subject_organization      = "Kubernetes"
  tls_kubelet_cert_subject_organization_unit = "Kubernetes"
  tls_kubelet_cert_subject_province          = "California"
  tls_kubelet_cert_subject_country           = "US"
  tls_kubelet_cert_validity_period_hours     = "1000"
  tls_kubelet_cert_early_renewal_hours       = "100"
  tls_kubelet_cert_ip_addresses              = "127.0.0.1"
  tls_kubelet_cert_dns_names                 = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local,*.${var.name}.${var.cloud_provider}.local"

  tls_proxy_cert_subject_common_name       = "system:kube-proxy"
  tls_proxy_cert_subject_locality          = "San Francisco"
  tls_proxy_cert_subject_organization      = "system:node-proxier"
  tls_proxy_cert_subject_organization_unit = "Kubernetes"
  tls_proxy_cert_subject_province          = "California"
  tls_proxy_cert_subject_country           = "US"
  tls_proxy_cert_validity_period_hours     = "1000"
  tls_proxy_cert_early_renewal_hours       = "100"
  tls_proxy_cert_ip_addresses              = "127.0.0.1"
  tls_proxy_cert_dns_names                 = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local"
}

module "kubeconfig" {
  source = "../kubeconfig"

  data_dir   = "${var.data_dir}"
  endpoint   = "master.${var.name}.${var.cloud_provider}.local"
  name       = "${var.name}"
  ca         = "${module.tls.ca}"
  client     = "${module.tls.admin}"
  client_key = "${module.tls.admin_key}"
}
