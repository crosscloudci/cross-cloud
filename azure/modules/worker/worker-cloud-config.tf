provider "gzip" {
  compressionlevel = "BestCompression"
}

resource "gzip_me" "k8s_cloud_config" {
  input = "${ var.k8s_cloud_config }"
}

resource "gzip_me" "ca" {
  input = "${ var.ca }"
}

resource "gzip_me" "k8s_worker" {
  input = "${ var.k8s_worker }"
}

resource "gzip_me" "k8s_worker_key" {
  input = "${ var.k8s_worker_key }"
}

data "template_file" "worker_cloud_config" {
  template = "${ file( "${ path.module }/worker-cloud-config.yml" )}"

  vars {
    cluster_domain = "${ var.cluster_domain }"
    dns_service_ip = "${ var.dns_service_ip }"
    kubelet_image_url = "${ var.kubelet_image_url }"
    kubelet_image_tag = "${ var.kubelet_image_tag }"
    internal_tld = "${ var.internal_tld }"
    location = "${ var.location }"
    k8s_cloud_config = "${ gzip_me.k8s_cloud_config.output }"
    ca = "${ gzip_me.ca.output }"
    k8s_worker = "${ gzip_me.k8s_worker.output }"
    k8s_worker_key = "${ gzip_me.k8s_worker_key.output }"
  }
}

