data "template_file" "kube_proxy" {
  template = "${ file( "${ path.module }/kube-proxy.yml" )}"
  vars {
    hyperkube = "${ var.kubelet_image_url }:${ var.kubelet_image_tag }"
    name = "${ var.name }"
    domain = "${ var.domain }"
  }
}

resource "gzip_me" "kube_proxy" {
  input = "${ data.template_file.kube_proxy.rendered }"
}

resource "gzip_me" "ca" {
  input = "${ var.ca }"
}

resource "gzip_me" "worker" {
  input = "${ var.worker }"
}

resource "gzip_me" "worker_key" {
  input = "${ var.worker_key }"
}

data "template_file" "cloud-config" {
  template = "${ file( "${ path.module }/cloud-config.yml" )}"

  vars {

    fqdn = "${ var.name}-worker${ count.index + 1 }.c.${ var.project }.internal"
    cluster_domain = "${ var.cluster_domain }"
    dns_service_ip = "${ var.dns_service_ip }"
    kubelet_image_url = "${ var.kubelet_image_url }"
    kubelet_image_tag = "${ var.kubelet_image_tag }"
    internal_tld = "${ var.internal_tld }"
    ca = "${ gzip_me.ca.output }"
    worker = "${ gzip_me.worker.output }"
    worker_key = "${ gzip_me.worker_key.output }"
    kube_proxy        = "${ gzip_me.kube_proxy.output }"
    name = "${ var.name }"
    domain = "${ var.domain }"
    etcd_discovery    = "${ var.etcd_discovery }"
  }
}
