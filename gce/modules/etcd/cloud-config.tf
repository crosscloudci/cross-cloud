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
    ca = "${ base64encode(var.ca) }"
    k8s-etcd = "${ base64encode(var.k8s-etcd) }"
    k8s-etcd-key = "${ base64encode(var.k8s-etcd-key) }"
    k8s-apiserver = "${ base64encode(var.k8s-apiserver) }"
    k8s-apiserver-key = "${ base64encode(var.k8s-apiserver-key) }"
    #name-servers-file = "${ var.name-servers-file }"
    etcd_discovery = "${ file(var.etcd_discovery) }"
    # cloud-config = "${ base64encode(var.cloud-config) }"

  }
}

