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
    kubelet_image_url = "${ var.kubelet_image_url }"
    kubelet_image_tag = "${ var.kubelet_image_tag }"
  }
}

data "template_file" "kube_proxy" {
  template = "${ file( "${ path.module }/kube-proxy.yml" )}"
  vars {
    kubelet_image_url = "${ var.kubelet_image_url }"
    kubelet_image_tag = "${ var.kubelet_image_tag }"
  }
}

data "template_file" "kube_scheduler" {
  template = "${ file( "${ path.module }/kube-scheduler.yml" )}"
  vars {
    kubelet_image_url = "${ var.kubelet_image_url }"
    kubelet_image_tag = "${ var.kubelet_image_tag }"
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

resource "gzip_me" "k8s_etcd" {
  input = "${ var.k8s_etcd }"
}

resource "gzip_me" "k8s_etcd_key" {
  input = "${ var.k8s_etcd_key }"
}

resource "gzip_me" "k8s_apiserver" {
  input = "${ var.k8s_apiserver }"
}

resource "gzip_me" "k8s_apiserver_key" {
  input = "${ var.k8s_apiserver_key }"
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
    k8s_etcd = "${ gzip_me.k8s_etcd.output }"
    k8s_etcd_key = "${ gzip_me.k8s_etcd_key.output }"
    k8s_apiserver = "${ gzip_me.k8s_apiserver.output }"
    k8s_apiserver_key = "${ gzip_me.k8s_apiserver_key.output }"
    k8s_apiserver_yml = "${ gzip_me.kube_apiserver.output }"
    k8s_proxy_yml = "${ gzip_me.kube_proxy.output }"
    k8s_scheduler_yml = "${ gzip_me.kube_scheduler.output }"
    k8s_controller_manager_yml = "${ gzip_me.kube_controller_manager.output }"
    etcd_discovery = "${ file(var.etcd_discovery) }"
  }
}
