data "template_file" "cloud-config" {
  template = "${ file( "${ path.module }/cloud-config.yml" )}"

  vars {
    cluster_domain = "${ var.cluster_domain }"
    dns_service_ip = "${ var.dns_service_ip }"
    kubelet_image_url = "${ var.kubelet_image_url }"
    kubelet_image_tag = "${ var.kubelet_image_tag }"
    internal_tld = "${ var.internal_tld }"
    ca = "${ base64encode(var.ca) }"
    k8s-worker = "${ base64encode(var.k8s-worker)  }"
    k8s-worker-key = "${ base64encode(var.k8s-worker-key) }"
    name = "${ var.name }"
    domain = "${ var.domain }"
    # cloud-config = "${ base64encode(var.cloud-config) }"
  }
}
