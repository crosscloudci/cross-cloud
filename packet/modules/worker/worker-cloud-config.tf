data "template_file" "kube_proxy" {
  template = "${ file( "${ path.module }/kube-proxy.yml" )}"
  vars {
    internal_tld = "${ var.internal_tld }"
    kubelet_image_url = "${ var.kubelet_image_url }"
    kubelet_image_tag = "${ var.kubelet_image_tag }"
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

resource "gzip_me" "k8s_etcd" {
  input = "${ var.k8s_etcd }"
}

resource "gzip_me" "k8s_etcd_key" {
  input = "${ var.k8s_etcd_key }"
}

resource "gzip_me" "k8s_worker" {
  input = "${ var.k8s_worker }"
}

resource "gzip_me" "k8s_worker_key" {
  input = "${ var.k8s_worker_key }"
}

data "template_file" "worker_user_data" {
  template = "${ file( "${ path.module }/worker-cloud-config.yml" )}"

  vars {
    cluster_domain    = "${ var.cluster_domain }"
    internal_tld      = "${ var.internal_tld }"
    dns_service_ip    = "${ var.dns_service_ip }"
    kubelet_image_url = "${ var.kubelet_image_url }"
    kubelet_image_tag = "${ var.kubelet_image_tag }"
    k8s_proxy_yml     = "${ gzip_me.kube_proxy.output }"
    ca                = "${ gzip_me.ca.output }"
    k8s_etcd          = "${ gzip_me.k8s_etcd.output }"
    k8s_etcd_key      = "${ gzip_me.k8s_etcd_key.output }"
    k8s_worker        = "${ gzip_me.k8s_worker.output }"
    k8s_worker_key    = "${ gzip_me.k8s_worker_key.output }"
    etcd_discovery    = "${file(var.etcd_discovery)}"
  }
}

