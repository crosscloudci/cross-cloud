resource "gzip_me" "ca" {
  input = "${ var.ca }"
}

resource "gzip_me" "worker" {
  input = "${ var.worker }"
}

resource "gzip_me" "worker_key" {
  input = "${ var.worker_key }"
}

resource "gzip_me" "proxy_kubeconfig" {
  input = "${ data.template_file.proxy_kubeconfig.rendered }"
}

resource "gzip_me" "kubelet_kubeconfig" {
  input = "${ data.template_file.kubelet_kubeconfig.rendered }"
}

resource "gzip_me" "kube_proxy" {
  input = "${ data.template_file.kube-proxy.rendered }"
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
    azure_cloud = "${ var.azure_cloud }"
    master_node = "${ var.internal_lb_ip }"
    ca = "${ gzip_me.ca.output }"
    worker = "${ gzip_me.worker.output }"
    worker_key = "${ gzip_me.worker_key.output }"
    proxy_kubeconfig = "${ gzip_me.proxy_kubeconfig.output }"
    kubelet_kubeconfig = "${ gzip_me.kubelet_kubeconfig.output }"
    kube_proxy = "${ gzip_me.kube_proxy.output }"
    # fqdn = "${ var.name }-worker${ count.index + 1 }.${ replace("${azurerm_network_interface.cncf.0.internal_fqdn}", "worker-${ var.name}1.", "")}"
    fqdn = "${ var.name }-worker${ count.index + 1 }"
  }
}

data "template_file" "kube-proxy" {
  template = "${ file( "${ path.module }/kube-proxy.yml" )}"

  vars {
    master_node = "${ var.name }-master1.${ replace("${azurerm_network_interface.cncf.0.internal_fqdn }", "worker-${ var.name}1", "")}"
    # master_node = "${ var.internal_lb_ip }"
    # fqdn = "${ var.name }-worker${ count.index + 1 }.${ replace("${azurerm_network_interface.cncf.0.internal_fqdn}", "worker-${ var.name}1.", "")}"
    fqdn = "${ var.name }-worker${ count.index + 1 }"
  }
}

data "template_file" "proxy_kubeconfig" {
  template = "${ file( "${ path.module }/kubeconfig" )}"

  vars {
    cluster = "certificate-authority-data: ${ base64encode(var.ca) } \n    server: https://${ var.name }-master1.${ replace("${azurerm_network_interface.cncf.0.internal_fqdn }", "worker-${ var.name}1", "")}"
    user = "kube-proxy"
    name = "service-account-context"
    user_authentication = "client-certificate-data: ${ base64encode(var.worker) } \n    client-key-data: ${ base64encode(var.worker_key) }"
  }
}

data "template_file" "kubelet_kubeconfig" {
  template = "${ file( "${ path.module }/kubeconfig" )}"

  vars {
    cluster = "certificate-authority-data: ${ base64encode(var.ca) } \n    server: https://${ var.name }-master1.${ replace("${azurerm_network_interface.cncf.0.internal_fqdn }", "worker-${ var.name}1", "")}"
    user = "kubelet"
    name = "service-account-context"
    user_authentication = "client-certificate-data: ${ base64encode(var.worker) } \n    client-key-data: ${ base64encode(var.worker_key) }"
  }
}

