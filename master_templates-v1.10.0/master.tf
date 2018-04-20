resource "gzip_me" "ca" {
  input = "${ var.ca }"
}

resource "gzip_me" "ca_key" {
  input = "${ var.ca_key }"
}

resource "gzip_me" "master" {
  count = "${ var.master_node_count }"
  input = "${ element(split(",", var.master), count.index) }"
}

resource "gzip_me" "master_key" {
  count = "${ var.master_node_count }"
  input = "${ element(split(",", var.master_key), count.index) }"
}

resource "gzip_me" "known_tokens_csv" {
  input = "${ data.template_file.known_tokens_csv.rendered }"
}

resource "gzip_me" "dns_conf" {
  input = "${ var.dns_conf }"
}

resource "gzip_me" "dns_dhcp" {
  input = "${ var.dns_dhcp }"
}

resource "gzip_me" "kube_apiserver" {
  count = "${ var.master_node_count }"
  input = "${ element(data.template_file.kube_apiserver.*.rendered, count.index) }"
}

data "template_file" "kube_apiserver" {
  count = "${ var.master_node_count }"
  template = "${ file( "${ path.module }/kube-apiserver" )}"
  vars {
    master_node_count = "${ var.master_node_count }"
    etcd_endpoint = "${ var.etcd_endpoint }"
    service_cidr = "${ var.service_cidr }"
    cloud_provider = "${ var.cloud_provider }"
    cloud_config = "${ var.cloud_config }"
  }
}




resource "gzip_me" "kube_controller_manager" {
  input = "${ data.template_file.kube_controller_manager.rendered }"
}

data "template_file" "kube_controller_manager" {
  template = "${ file( "${ path.module }/kube-controller-manager" )}"
  vars {
    pod_cidr = "${ var.pod_cidr }"
    service_cidr = "${ var.service_cidr }"
    cluster_name = "${ var.cluster_name }"
    cloud_provider = "${ var.cloud_provider }"
    cloud_config = "${ var.cloud_config }"
  }
}




resource "gzip_me" "kube_controller_manager_kubeconfig" {
  input = "${ data.template_file.kube_controller_manager_kubeconfig.rendered }"
}

data "template_file" "kube_controller_manager_kubeconfig" {
  template = "${ file( "${ path.module }/kubeconfig" )}"
  vars {
    cluster = "certificate-authority: /etc/srv/kubernetes/pki/ca-certificates.crt \n    server: https://127.0.0.1"
    user = "kube-controller-manager"
    name = "service-account-context"
    user_authentication = "client-certificate: /etc/srv/kubernetes/pki/master.crt \n    client-key: /etc/srv/kubernetes/pki/master.key"
  }
}




resource "gzip_me" "kube_scheduler_kubeconfig" {
  input = "${ data.template_file.kube_scheduler_kubeconfig.rendered }"
}

data "template_file" "kube_scheduler_kubeconfig" {
  template = "${ file( "${ path.module }/kubeconfig" )}"
  vars {
    cluster = "certificate-authority: /etc/srv/kubernetes/pki/ca-certificates.crt \n    server: https://127.0.0.1"
    user = "kube-scheduler"
    name = "service-account-context"
    user_authentication = "client-certificate: /etc/srv/kubernetes/pki/master.crt \n    client-key: /etc/srv/kubernetes/pki/master.key"
  }
}


data "template_file" "master" {
  count = "${ var.master_node_count }"
  template = "${ file( "${ path.module }/master.yml" )}"

  vars {
    name = "${ var.name }"
    node = "${ var.name }-master-${ count.index +1 }"
    etcd_artifact = "${ var.etcd_artifact }"
    etcd_discovery = "${ var.etcd_discovery }"
    kube_apiserver = "${ element(gzip_me.kube_apiserver.*.output, count.index) }"
    kube_apiserver_artifact = "${ var.kube_apiserver_artifact }"
    kube_controller_manager = "${ element(gzip_me.kube_controller_manager.*.output, count.index) }" 
    kube_controller_manager_artifact = "${ var.kube_controller_manager_artifact }"
    kube_scheduler_artifact = "${ var.kube_scheduler_artifact }"
    cloud_config_file = "${ base64gzip(var.cloud_config_file) }"
    service_cidr = "${ var.service_cidr }"
    ca = "${ gzip_me.ca.output }"
    ca_key = "${ gzip_me.ca_key.output }"
    master = "${ element(gzip_me.master.*.output, count.index) }"
    master_key = "${ element(gzip_me.master_key.*.output, count.index) }"
    known_tokens_csv = "${ gzip_me.known_tokens_csv.output }"
    kube_controller_manager_kubeconfig = "${ gzip_me.kube_controller_manager_kubeconfig.output }"
    kube_scheduler_kubeconfig = "${ gzip_me.kube_scheduler_kubeconfig.output }"
    dns_conf = "${ gzip_me.dns_conf.output }"
    dns_dhcp = "${ gzip_me.dns_dhcp.output }"

  }
}
