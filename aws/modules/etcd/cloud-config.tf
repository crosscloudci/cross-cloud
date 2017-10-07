resource "gzip_me" "ca" {
  input = "${ var.ca }"
}

resource "gzip_me" "apiserver" {
  input = "${ var.apiserver }"
}

resource "gzip_me" "apiserver_key" {
  input = "${ var.apiserver_key }"
}

data "template_file" "kube-apiserver" {
  template = "${ file( "${ path.module }/kube-apiserver.yml" )}"

  vars {
    fqdn = "etcd${ count.index + 1 }.${ var.internal_tld }"
    internal_tld = "${ var.internal_tld }"
    service_cidr = "${ var.service_cidr }"
    hyperkube = "${ var.kubelet_image_url }:${ var.kubelet_image_tag }"
    kubelet_image_url = "${ var.kubelet_image_url }"
    kubelet_image_tag = "${ var.kubelet_image_tag }"
  }
}

resource "gzip_me" "kube-apiserver" {
  input = "${ data.template_file.kube-apiserver.rendered }"
}

data "template_file" "kube-controller-manager" {
  template = "${ file( "${ path.module }/kube-controller-manager.yml" )}"

  vars {
    hyperkube = "${ var.kubelet_image_url }:${ var.kubelet_image_tag }"
  }
}

resource "gzip_me" "kube-controller-manager" {
  input = "${ data.template_file.kube-controller-manager.rendered }"
}

data "template_file" "kube-proxy" {
  template = "${ file( "${ path.module }/kube-proxy.yml" )}"

  vars {
    fqdn = "etcd${ count.index + 1 }.${ var.internal_tld }"
    internal_tld = "${ var.internal_tld }"
    service_cidr = "${ var.service_cidr }"
    hyperkube = "${ var.kubelet_image_url }:${ var.kubelet_image_tag }"
    kubelet_image_url = "${ var.kubelet_image_url }"
    kubelet_image_tag = "${ var.kubelet_image_tag }"
  }
}

resource "gzip_me" "kube-proxy" {
  input = "${ data.template_file.kube-proxy.rendered }"
}


data "template_file" "kube-scheduler" {
  template = "${ file( "${ path.module }/kube-scheduler.yml" )}"

  vars {
    fqdn = "etcd${ count.index + 1 }.${ var.internal_tld }"
    internal_tld = "${ var.internal_tld }"
    service_cidr = "${ var.service_cidr }"
    hyperkube = "${ var.kubelet_image_url }:${ var.kubelet_image_tag }"
    kubelet_image_url = "${ var.kubelet_image_url }"
    kubelet_image_tag = "${ var.kubelet_image_tag }"
  }
}

resource "gzip_me" "kube-scheduler" {
  input = "${ data.template_file.kube-scheduler.rendered }"
}

data "template_file" "cloud-config" {
  count = "${ var.master_node_count }"
  template = "${ file( "${ path.module }/cloud-config.yml" )}"

  vars {
    cluster_domain = "${ var.cluster_domain }"
    cluster-token = "etcd-cluster-${ var.name }"
    dns_service_ip = "${ var.dns_service_ip }"
    fqdn = "etcd${ count.index + 1 }.${ var.internal_tld }"
    hostname = "etcd${ count.index + 1 }"
    hyperkube = "${ var.kubelet_image_url }:${ var.kubelet_image_tag }"
    kubelet_image_url = "${ var.kubelet_image_url }"
    kubelet_image_tag = "${ var.kubelet_image_tag }"
    internal_tld = "${ var.internal_tld }"
    pod_cidr = "${ var.pod_cidr }"
    region = "${ var.region }"
    service_cidr = "${ var.service_cidr }"
    ca = "${ gzip_me.ca.output }"
    apiserver = "${ gzip_me.apiserver.output }"
    apiserver_key = "${ gzip_me.apiserver_key.output }"
    kube_apiserver = "${ gzip_me.kube-apiserver.output }"
    kube_controller_manager = "${ gzip_me.kube-controller-manager.output }"
    kube_proxy = "${ gzip_me.kube-proxy.output }"
    kube_scheduler = "${ gzip_me.kube-scheduler.output }"
  }
}


