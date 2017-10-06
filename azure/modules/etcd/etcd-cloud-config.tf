provider "gzip" {
  compressionlevel = "BestCompression"
}

data "template_file" "etcd" {
  count = "${ var.master_node_count }"
  template = "${ file( "${ path.module }/etcd.yml" )}"
  vars {
    etcd_registry = "${ var.etcd_registry }"
    etcd_tag = "${ var.etcd_tag }"
    etcd_discovery = "${ etcdiscovery_token.etcd.id }"
    fqdn = "${ var.name }-master${ count.index + 1 }.${ replace("${azurerm_network_interface.cncf.0.internal_fqdn}", "${ var.name}1.", "")}"
  }
}

data "template_file" "etcd_events" {
  count = "${ var.master_node_count }"
  template = "${ file( "${ path.module }/etcd-events.yml" )}"
  vars {
    etcd_registry = "${ var.etcd_registry }"
    etcd_tag = "${ var.etcd_tag }"
    etcd_events_discovery = "${ etcdiscovery_token.etcd_events.id }"
    fqdn = "${ var.name }-master${ count.index + 1 }.${ replace("${azurerm_network_interface.cncf.0.internal_fqdn}", "${ var.name}1.", "")}"
  }
}

data "template_file" "kubelet_kubeconfig" {
  template = "${ file( "${ path.module }/kubeconfig" )}"
  vars {
    cluster = "certificate-authority-data: ${ base64encode(var.ca) } \n    server: https://127.0.0.1"
    user = "kubelet"
    name = "service-account-context"
    user_authentication = "client-certificate-data: ${ base64encode(var.apiserver) } \n    client-key-data: ${ base64encode(var.apiserver_key) }"
  }
}

data "template_file" "kube_apiserver" {
  count = "${ var.master_node_count }"
  template = "${ file( "${ path.module }/kube-apiserver.yml" )}"
  vars {
    kube_apiserver_registry = "${ var.kube_apiserver_registry }"
    kube_apiserver_tag = "${ var.kube_apiserver_tag }"
    fqdn = "${ var.name }-master${ count.index + 1 }.${ replace("${azurerm_network_interface.cncf.0.internal_fqdn}", "${ var.name}1.", "")}"
    service_cidr = "${ var.service_cidr }"
    master_node_count = "${ var.master_node_count }"
    cloud_provider = "${ var.cloud_provider }"
    cloud_config = "${ var.cloud_config }"
  }
}

data "template_file" "kube_controller_manager" {
  template = "${ file( "${ path.module }/kube-controller-manager.yml" )}"
  vars {
    kube_controller_manager_registry = "${ var.kube_controller_manager_registry }"
    kube_controller_manager_tag = "${ var.kube_controller_manager_tag }"
    pod_cidr = "${ var.pod_cidr }"
    cluster_domain = "${ var.cluster_domain }"
    cloud_provider = "${ var.cloud_provider }"
    cloud_config = "${ var.cloud_config }"
  }
}

data "template_file" "kube_controller_manager_kubeconfig" {
  template = "${ file( "${ path.module }/kubeconfig" )}"
  vars {
    cluster = "certificate-authority-data: ${ base64encode(var.ca) } \n    server: https://127.0.0.1"
    user = "kube-controller-manager"
    name = "service-account-context"
    user_authentication = "client-certificate-data: ${ base64encode(var.apiserver) } \n    client-key-data: ${ base64encode(var.apiserver_key) }"
  }
}

data "template_file" "kube_scheduler" {
  template = "${ file( "${ path.module }/kube-scheduler.yml" )}"
  vars {
    kube_scheduler_registry = "${ var.kube_scheduler_registry }"
    kube_scheduler_tag = "${ var.kube_scheduler_tag }"
  }
}

data "template_file" "kube_scheduler_kubeconfig" {
  template = "${ file( "${ path.module }/kubeconfig" )}"
  vars {
    cluster = "certificate-authority-data: ${ base64encode(var.ca) } \n    server: https://127.0.0.1"
    user = "kube-scheduler"
    name = "service-account-context"
    user_authentication = "client-certificate-data: ${ base64encode(var.apiserver) } \n    client-key-data: ${ base64encode(var.apiserver_key) }"
  }
}

data "template_file" "kube-proxy" {
  count = "${ var.master_node_count }"
  template = "${ file( "${ path.module }/kube-proxy.yml" )}"

  vars {
    fqdn = "${ var.name }-master${ count.index + 1 }"
    pod_cidr = "${ var.pod_cidr }"
    kube_proxy_registry = "${ var.kube_proxy_registry }"
    kube_proxy_tag = "${ var.kube_proxy_tag }"
  }
}

data "template_file" "proxy_kubeconfig" {
  template = "${ file( "${ path.module }/kubeconfig" )}"

  vars {
    cluster = "certificate-authority-data: ${ base64encode(var.ca) } \n    server: https://127.0.0.1"
    user = "kube-proxy"
    name = "service-account-context"
    user_authentication = "client-certificate-data: ${ base64encode(var.apiserver) } \n    client-key-data: ${ base64encode(var.apiserver_key) }"
  }
}

data "template_file" "cloud_config_file" {
  template = "${ file( "${ path.module }/azure_cloud.json" )}"
  vars {
    client_id = "${ var.client_id }"
    client_secret = "${ var.client_secret }"
    tenant_id = "${ var.tenant_id }"
    subscription_id = "${ var.subscription_id }"
    name = "${ var.name }"
    location = "${ var.location }"
    subnet_name = "subnet-${ var.name}"
  }
}

resource "gzip_me" "etcd" {
  count = "${ var.master_node_count }"
  input = "${ element(data.template_file.etcd.*.rendered, count.index) }"
}

resource "gzip_me" "etcd_events" {
  count = "${ var.master_node_count }"
  input = "${ element(data.template_file.etcd_events.*.rendered, count.index) }"
}

resource "gzip_me" "kubelet_kubeconfig" {
  input = "${ data.template_file.kubelet_kubeconfig.rendered }"
}

resource "gzip_me" "kube_apiserver" {
  count = "${ var.master_node_count }"
  input = "${ element(data.template_file.kube_apiserver.*.rendered, count.index) }"
}

resource "gzip_me" "kube_controller_manager" {
  input = "${ data.template_file.kube_controller_manager.rendered }"
}

resource "gzip_me" "kube_controller_manager_kubeconfig" {
  input = "${ data.template_file.kube_controller_manager_kubeconfig.rendered }"
}

resource "gzip_me" "kube_scheduler" {
  input = "${ data.template_file.kube_scheduler.rendered }"
}

resource "gzip_me" "kube_scheduler_kubeconfig" {
  input = "${ data.template_file.kube_scheduler_kubeconfig.rendered }"
}

resource "gzip_me" "kube_proxy" {
  count = "${ var.master_node_count}"
  input = "${ element(data.template_file.kube-proxy.*.rendered, count.index) }"
}

resource "gzip_me" "proxy_kubeconfig" {
  input = "${ data.template_file.proxy_kubeconfig.rendered }"
}

resource "gzip_me" "cloud_config_file" {
  input = "${ data.template_file.cloud_config_file.rendered }"
}

resource "gzip_me" "ca" {
  input = "${ var.ca }"
}

resource "gzip_me" "ca_key" {
  input = "${ var.ca_key }"
}

resource "gzip_me" "apiserver" {
  input = "${ var.apiserver }"
}

resource "gzip_me" "apiserver_key" {
  input = "${ var.apiserver_key }"
}



data "template_file" "etcd_cloud_config" {
  count = "${ var.master_node_count }"
  template = "${ file( "${ path.module }/etcd-cloud-config.yml" )}"

  vars {
    cluster_domain = "${ var.cluster_domain }"
    cloud_provider = "${ var.cloud_provider }"
    cloud_config = "${ var.cloud_config }"
    cluster-token = "etcd-cluster-${ var.name }"
    etcd_discovery = "${ etcdiscovery_token.etcd.id }"
    dns_service_ip = "${ var.dns_service_ip }"
    fqdn = "${ var.name }-master${ count.index + 1 }.${ replace("${azurerm_network_interface.cncf.0.internal_fqdn}", "${ var.name}1.", "")}"
    fqdn_short = "${ var.name }-master${ count.index + 1}"
    hostname = "${ var.name}-master${ count.index + 1 }"
    internal_tld = "${ var.internal_tld }"
    pod_cidr = "${ var.pod_cidr }"
    location = "${ var.location }"
    service_cidr = "${ var.service_cidr }"
    non_masquerade_cidr = "${ var.non_masquerade_cidr }"
    cloud_config_file = "${ gzip_me.cloud_config_file.output }"
    ca = "${ gzip_me.ca.output }"
    ca_key = "${ gzip_me.ca_key.output }"
    apiserver = "${ gzip_me.apiserver.output }"
    apiserver_key = "${ gzip_me.apiserver_key.output }"
    kubelet_kubeconfig = "${ gzip_me.kubelet_kubeconfig.output }"
    kubelet_artifact = "${ var.kubelet_artifact }"
    cni_artifact = "${ var.cni_artifact }"
    etcd = "${ element(gzip_me.etcd.*.output, count.index) }"
    etcd_events = "${ element(gzip_me.etcd_events.*.output, count.index) }"
    kube_apiserver = "${ element(gzip_me.kube_apiserver.*.output, count.index) }"
    kube_scheduler = "${ gzip_me.kube_scheduler.output }"
    kube_scheduler_kubeconfig = "${ gzip_me.kube_scheduler_kubeconfig.output }"
    kube_controller_manager = "${ gzip_me.kube_controller_manager.output }"
    kube_controller_manager_kubeconfig = "${ gzip_me.kube_controller_manager_kubeconfig.output }"
    kube_proxy = "${ element(gzip_me.kube_proxy.*.output, count.index) }"
    proxy_kubeconfig = "${ gzip_me.proxy_kubeconfig.output }"
    known_tokens_csv = "${ gzip_me.known_tokens_csv.output }"
    basic_auth_csv = "${ gzip_me.basic_auth_csv.output }"

  }
}
