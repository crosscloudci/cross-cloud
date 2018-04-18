resource "gzip_me" "ca" {
  input = "${ var.ca }"
}

resource "gzip_me" "worker" {
  count = "${ var.worker_node_count }"
  input = "${ element(split(",", var.worker), count.index) }"
}

resource "gzip_me" "worker_key" {
  count = "${ var.worker_node_count }"
  input = "${ element(split(",", var.worker_key), count.index) }"
}

resource "gzip_me" "dns_conf" {
  input = "${ var.dns_conf }"
}

resource "gzip_me" "dns_dhcp" {
  input = "${ var.dns_dhcp }"
}





resource "gzip_me" "kubelet" {
  count = "${ var.worker_node_count }"
  input = "${ element(data.template_file.kubelet.*.rendered, count.index) }"
}

data "template_file" "kubelet" {
  count = "${ var.worker_node_count }"
  template = "${ file( "${ path.module }/kubelet" )}"

  vars {
    cluster_domain = "${ var.cluster_domain }"
    cloud_provider = "${ var.cloud_provider }"
    cloud_config = "${ var.cloud_config }"
    dns_service_ip = "${ var.dns_service_ip }"
    non_masquerade_cidr = "${ var.non_masquerade_cidr }"
  }
}






resource "gzip_me" "kubelet_kubeconfig" {
  input = "${ data.template_file.kubelet_kubeconfig.rendered }"
}

data "template_file" "kubelet_kubeconfig" {
  template = "${ file( "${ path.module }/kubeconfig" )}"

  vars {
    cluster = "certificate-authority: /etc/srv/kubernetes/pki/ca-certificates.crt \n    server: https://${ var.internal_lb_ip }"
    user = "kubelet"
    name = "service-account-context"
    user_authentication = "client-certificate: /etc/srv/kubernetes/pki/kubelet.crt \n    client-key: /etc/srv/kubernetes/pki/kubelet.key"
  }
}





resource "gzip_me" "proxy_kubeconfig" {
  input = "${ data.template_file.proxy_kubeconfig.rendered }"
}

data "template_file" "proxy_kubeconfig" {
  template = "${ file( "${ path.module }/kubeconfig" )}"

  vars {
    cluster = "certificate-authority: /etc/srv/kubernetes/pki/ca-certificates.crt \n    server: https://${ var.internal_lb_ip }"
    user = "kube-proxy"
    name = "service-account-context"
    user_authentication = "client-certificate: /etc/srv/kubernetes/pki/worker.crt \n    client-key: /etc/srv/kubernetes/pki/worker.key"
  }
}





resource "gzip_me" "kube_proxy" {
  count = "${ var.worker_node_count}"
  input = "${ element(data.template_file.kube-proxy.*.rendered, count.index) }"
}

data "template_file" "kube-proxy" {
  count = "${ var.worker_node_count }"
  template = "${ file( "${ path.module }/kube-proxy.yml" )}"

  vars {
    hostname = "${ var.hostname }-${ count.index + 1 }.${ var.hostname_suffix }"
    master_node = "${ var.internal_lb_ip }"
    pod_cidr = "${ var.pod_cidr }"
    kube_proxy_image = "${ var.kube_proxy_image }"
    kube_proxy_tag = "${ var.kube_proxy_tag }"

  }
}





data "template_file" "worker" {
  count = "${ var.worker_node_count }"
  template = "${ file( "${ path.module }/worker.yml" )}"

  vars {
    cloud_config_file = "${ base64gzip(var.cloud_config_file) }"
    ca = "${ gzip_me.ca.output }"
    worker = "${ element(gzip_me.worker.*.output, count.index) }"
    worker_key = "${ element(gzip_me.worker_key.*.output, count.index) }"
    kubelet = "${ element(gzip_me.kubelet.*.output, count.index) }"
    kubelet_kubeconfig = "${ gzip_me.kubelet_kubeconfig.output }"
    kube_proxy = "${ element(gzip_me.kube_proxy.*.output, count.index) }"
    proxy_kubeconfig = "${ gzip_me.proxy_kubeconfig.output }"
    kubelet_artifact = "${ var.kubelet_artifact }"
    cni_artifact = "${ var.cni_artifact }"
    dns_conf = "${ gzip_me.dns_conf.output }"
    dns_dhcp = "${ gzip_me.dns_dhcp.output }"

  }
}
