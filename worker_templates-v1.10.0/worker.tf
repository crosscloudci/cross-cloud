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

data "template_file" "kubelet_bootstrap_kubeconfig" {
  template = "${ file( "${ path.module }/kubeconfig" )}"

  vars {
    cluster = "certificate-authority: /etc/srv/kubernetes/pki/ca-certificates.crt \n    server: https://${ var.internal_lb_ip }"
    user = "kubelet-bootstrap"
    name = "service-account-context"
    user_authentication = "token: ${ var.bootstrap }"
  }
}

data "template_file" "proxy_kubeconfig" {
  template = "${ file( "${ path.module }/kubeconfig" )}"

  vars {
    cluster = "certificate-authority: /etc/srv/kubernetes/pki/ca-certificates.crt \n    server: https://${ var.internal_lb_ip }"
    user = "kube-proxy"
    name = "service-account-context"
    user_authentication = "client-certificate: /etc/srv/kubernetes/pki/proxy.crt \n    client-key: /etc/srv/kubernetes/pki/proxy.key"
  }
}


data "template_file" "kube-proxy" {
  count = "${ var.worker_node_count }"
  template = "${ file( "${ path.module }/kube-proxy.yml" )}"

  vars {
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
    hostname = "${ var.hostname }-${ count.index + 1 }.${ var.hostname_suffix }"
    hostname_path = "${ var.hostname_path }"
    cloud_config_file = "${ base64encode(var.cloud_config_file) }"
    ca = "${ base64encode(var.ca) }"
    kubelet_crt = "${ base64encode(var.kubelet) }"
    kubelet_key = "${ base64encode(var.kubelet_key) }"
    proxy = "${ base64encode(var.proxy) }"
    proxy_key = "${ base64encode(var.proxy_key) }"
    kubelet = "${ base64encode(element(data.template_file.kubelet.*.rendered, count.index)) }"
    kubelet_bootstrap_kubeconfig = "${ base64encode(data.template_file.kubelet_bootstrap_kubeconfig.rendered) }"
    kube_proxy = "${ base64encode(element(data.template_file.kube-proxy.*.rendered, count.index)) }"
    proxy_kubeconfig = "${ base64encode(data.template_file.proxy_kubeconfig.rendered) }"
    kubelet_artifact = "${ var.kubelet_artifact }"
    cni_artifact = "${ var.cni_artifact }"
    cni_plugins_artifact = "${ var.cni_plugins_artifact }"
    dns_conf = "${ base64encode(var.dns_conf) }"
    dns_dhcp = "${ base64encode(var.dns_dhcp) }"

  }
}
