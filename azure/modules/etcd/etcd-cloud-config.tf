provider "gzip" {
  compressionlevel = "BestCompression"
}

data "template_file" "kube_apiserver" {
  count = "${ var.master_node_count }"
  template = "${ file( "${ path.module }/kube-apiserver.yml" )}"
  vars {
    fqdn = "${ var.name }-master${ count.index + 1 }.${ replace("${azurerm_network_interface.cncf.0.internal_fqdn}", "${ var.name}1.", "")}"
    internal_tld = "${ var.internal_tld }"
    service_cidr = "${ var.service_cidr }"
    master_node_count = "${ var.master_node_count }"
    hyperkube = "${ var.kubelet_image_url }:${ var.kubelet_image_tag }"
    kubelet_image_url = "${ var.kubelet_image_url }"
    kubelet_image_tag = "${ var.kubelet_image_tag }"
  }
}

data "template_file" "kube_controller_manager" {
  template = "${ file( "${ path.module }/kube-controller-manager.yml" )}"
  vars {
    hyperkube = "${ var.kubelet_image_url }:${ var.kubelet_image_tag }"
  }
}

data "template_file" "kube_proxy" {
  template = "${ file( "${ path.module }/kube-proxy.yml" )}"
  vars {
    hyperkube = "${ var.kubelet_image_url }:${ var.kubelet_image_tag }"
  }
}

data "template_file" "kube_scheduler" {
  template = "${ file( "${ path.module }/kube-scheduler.yml" )}"
  vars {
    hyperkube = "${ var.kubelet_image_url }:${ var.kubelet_image_tag }"
  }
}

data "template_file" "azure_cloud" {
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

resource "gzip_me" "kube_apiserver" {
  count = "${ var.master_node_count }"
  input = "${ element(data.template_file.kube_apiserver.*.rendered, count.index) }"
}

resource "gzip_me" "kube_controller_manager" {
  input = "${ data.template_file.kube_controller_manager.rendered }"
}

resource "gzip_me" "kube_proxy" {
  input = "${ data.template_file.kube_proxy.rendered }"
}

resource "gzip_me" "kube_scheduler" {
  input = "${ data.template_file.kube_scheduler.rendered }"
}

resource "gzip_me" "cloud_config" {
  input = "${ data.template_file.azure_cloud.rendered }"
}

resource "gzip_me" "ca" {
  input = "${ var.ca }"
}

resource "gzip_me" "ca_key" {
  input = "${ var.ca_key }"
}

resource "gzip_me" "etcd" {
  input = "${ var.etcd }"
}

resource "gzip_me" "etcd_key" {
  input = "${ var.etcd_key }"
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
    cluster-token = "etcd-cluster-${ var.name }"
    etcd_discovery = "${ etcdiscovery_token.etcd.id }"
    dns_service_ip = "${ var.dns_service_ip }"
    fqdn = "${ var.name }-master${ count.index + 1 }.${ replace("${azurerm_network_interface.cncf.0.internal_fqdn}", "${ var.name}1.", "")}"
    hostname = "${ var.name}-master${ count.index + 1 }"
    kubelet_image_url = "${ var.kubelet_image_url }"
    kubelet_image_tag = "${ var.kubelet_image_tag }"
    internal_tld = "${ var.internal_tld }"
    pod_cidr = "${ var.pod_cidr }"
    location = "${ var.location }"
    service_cidr = "${ var.service_cidr }"
    cloud_config = "${ gzip_me.cloud_config.output }"
    ca = "${ gzip_me.ca.output }"
    ca_key = "${ gzip_me.ca_key.output }"
    etcd = "${ gzip_me.etcd.output }"
    etcd_key = "${ gzip_me.etcd_key.output }"
    apiserver = "${ gzip_me.apiserver.output }"
    apiserver_key = "${ gzip_me.apiserver_key.output }"
    kube_apiserver = "${ element(gzip_me.kube_apiserver.*.output, count.index) }"
    # kube_proxy = "${ gzip_me.kube_proxy.output }"
    kube_scheduler = "${ gzip_me.kube_scheduler.output }"
    kube_controller_manager = "${ gzip_me.kube_controller_manager.output }"
    known_tokens_csv = "${ gzip_me.known_tokens_csv.output }"
    basic_auth_csv = "${ gzip_me.basic_auth_csv.output }"
    abac_authz_policy = "${ gzip_me.abac_authz_policy.output}"

  }
}
