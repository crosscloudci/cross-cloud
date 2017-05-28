data "template_file" "kube_apiserver" {
  template = "${ file( "${ path.module }/kube-apiserver.yml" )}"
  vars {
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

provider "gzip" {
  compressionlevel = "BestCompression"
}

resource "gzip_me" "kube_apiserver" {
  input = "${ data.template_file.kube_apiserver.rendered }"
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

data "template_file" "etcd_user_data" {
  count = "${ var.master_node_count }"
  template = "${ file( "${ path.module }/etcd-cloud-config.yml" )}"

  vars {
    fqdn = "etcd${ count.index + 1 }.${ var.internal_tld }"
    cluster_domain = "${ var.cluster_domain }"
    dns_service_ip = "${ var.dns_service_ip }"
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
    kube_apiserver = "${ gzip_me.kube_apiserver.output }"
    kube_proxy = "${ gzip_me.kube_proxy.output }"
    kube_scheduler = "${ gzip_me.kube_scheduler.output }"
    kube_controller_manager = "${ gzip_me.kube_controller_manager.output }"
    # etcd_discovery = "${ file(var.etcd_discovery) }"
  }
}
