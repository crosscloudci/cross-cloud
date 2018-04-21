resource "gzip_me" "ca" {
  input = "${ var.ca }"
}

resource "gzip_me" "ca_key" {
  input = "${ var.ca_key }"
}

resource "gzip_me" "apiserver" {
  input = "${ var.apiserver }"
}

resource "gzip_me" "apiserver_key" {
  input = "${ var.apiserver_key }"
}

resource "gzip_me" "controller" {
  input = "${ var.controller }"
}

resource "gzip_me" "controller_key" {
  input = "${ var.controller_key }"
}

resource "gzip_me" "scheduler" {
  input = "${ var.scheduler }"
}

resource "gzip_me" "scheduler_key" {
  input = "${ var.scheduler_key }"
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




resource "gzip_me" "kube_scheduler" {
  input = "${ data.template_file.kube_scheduler.rendered }"
}

data "template_file" "kube_scheduler" {
  template = "${ file( "${ path.module }/kube-scheduler" )}"
  vars {
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
    user_authentication = "client-certificate: /etc/srv/kubernetes/pki/controller.crt \n    client-key: /etc/srv/kubernetes/pki/controller.key"
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
    user_authentication = "client-certificate: /etc/srv/kubernetes/pki/scheduler.crt \n    client-key: /etc/srv/kubernetes/pki/scheduler.key"
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
    kube_scheduler = "${ element(gzip_me.kube_scheduler.*.output, count.index) }"
    kube_scheduler_artifact = "${ var.kube_scheduler_artifact }"
    cloud_config_file = "${ base64gzip(var.cloud_config_file) }"
    ca = "${ gzip_me.ca.output }"
    ca_key = "${ gzip_me.ca_key.output }"
    apiserver = "${ gzip_me.apiserver.output }"
    apiserver_key = "${ gzip_me.apiserver_key.output }"
    controller = "${ gzip_me.controller.output }"
    controller_key = "${ gzip_me.controller_key.output }"
    scheduler = "${ gzip_me.scheduler.output }"
    scheduler_key = "${ gzip_me.scheduler_key.output }"
    known_tokens_csv = "${ gzip_me.known_tokens_csv.output }"
    kube_controller_manager_kubeconfig = "${ gzip_me.kube_controller_manager_kubeconfig.output }"
    kube_scheduler_kubeconfig = "${ gzip_me.kube_scheduler_kubeconfig.output }"
    dns_conf = "${ gzip_me.dns_conf.output }"
    dns_dhcp = "${ gzip_me.dns_dhcp.output }"

  }
}
