data "template_file" "kube_apiserver" {
  count = "${ var.master_node_count }"
  template = "${ file( "${ path.module }/kube-apiserver.yml" )}"
  vars {
    fqdn = "${ var.name}-master${ count.index + 1 }.c.${ var.project }.internal"
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

resource "gzip_me" "ca" {
  input = "${ var.ca }"
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

data "template_file" "cloud-config" {
  count = "${ var.master_node_count }"
  template = "${ file( "${ path.module }/cloud-config.yml" )}"

  vars {
    cluster_domain = "${ var.cluster_domain }"
    cluster-token = "etcd-cluster-${ var.name }"
    dns_service_ip = "${ var.dns_service_ip }"
    etc-tar = "/manifests/etc.tar"
    fqdn = "${ var.name}-master${ count.index + 1 }.c.${ var.project }.internal"
    hostname = "${ var.name }-master${ count.index + 1 }.c.${ var.project }.internal"
    kubelet_image_url = "${ var.kubelet_image_url }"
    kubelet_image_tag = "${ var.kubelet_image_tag }"
    internal_tld = "${ var.internal_tld }"
    pod_cidr = "${ var.pod_cidr }"
    service_cidr = "${ var.service_cidr }"
    ca = "${ gzip_me.ca.output }"
    etcd = "${ gzip_me.etcd.output }"
    etcd_key = "${ gzip_me.etcd_key.output }"
    apiserver = "${ gzip_me.apiserver.output }"
    apiserver_key = "${ gzip_me.apiserver_key.output }"
    kube_apiserver = "${ element(gzip_me.kube_apiserver.*.output, count.index) }"
    kube_proxy = "${ gzip_me.kube_proxy.output }"
    kube_scheduler = "${ gzip_me.kube_scheduler.output }"
    kube_controller_manager = "${ gzip_me.kube_controller_manager.output }"
    #name-servers-file = "${ var.name-servers-file }"
    etcd_discovery = "${ etcdiscovery_token.etcd.id }"
    # cloud-config = "${ base64encode(var.cloud-config) }"

  }
}

