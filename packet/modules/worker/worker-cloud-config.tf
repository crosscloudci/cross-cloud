data "template_file" "kube_proxy" {
  template = "${ file( "${ path.module }/kube-proxy.yml" )}"
  vars {
    hyperkube = "${ var.kubelet_image_url }:${ var.kubelet_image_tag }"
    internal_tld = "${ var.internal_tld }"
  }
}

provider "gzip" {
  compressionlevel = "BestCompression"
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

data "template_file" "worker_user_data" {
  template = "${ file( "${ path.module }/worker-cloud-config.yml" )}"

  vars {
    cluster_domain    = "${ var.cluster_domain }"
    internal_tld      = "${ var.internal_tld }"
    dns_service_ip    = "${ var.dns_service_ip }"
    kubelet_image_url = "${ var.kubelet_image_url }"
    kubelet_image_tag = "${ var.kubelet_image_tag }"
    kube_proxy        = "${ gzip_me.kube_proxy.output }"
    ca                = "${ gzip_me.ca.output }"
    worker            = "${ gzip_me.worker.output }"
    worker_key        = "${ gzip_me.worker_key.output }"
    etcd_discovery    = "${ var.etcd_discovery }"
  }
}

