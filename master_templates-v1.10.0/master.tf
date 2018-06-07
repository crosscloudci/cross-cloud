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

data "template_file" "kube_controller_manager" {
  template = "${ file( "${ path.module }/kube-controller-manager" )}"
  vars {
    pod_cidr = "${ var.pod_cidr }"
    service_cidr = "${ var.service_cidr }"
    cluster_name = "${ var.name }"
    cloud_provider = "${ var.cloud_provider }"
    cloud_config = "${ var.cloud_config }"
  }
}


data "template_file" "kube_scheduler" {
  template = "${ file( "${ path.module }/kube-scheduler" )}"
  vars {
  }
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
    hostname = "${ var.hostname }-${ count.index + 1 }.${ var.hostname_suffix }"
    hostname_path = "${ var.hostname_path }"
    node = "${ var.name }-master-${ count.index + 1 }"
    etcd_artifact = "${ var.etcd_artifact }"
    etcd_discovery = "${ var.etcd_discovery }"
    kube_apiserver = "${ base64encode(element(data.template_file.kube_apiserver.*.rendered, count.index)) }"
    kube_apiserver_artifact = "${ var.kube_apiserver_artifact }"
    kube_controller_manager = "${ base64encode(data.template_file.kube_controller_manager.rendered) }" 
    kube_controller_manager_artifact = "${ var.kube_controller_manager_artifact }"
    kube_scheduler = "${ base64encode(data.template_file.kube_scheduler.rendered) }"
    kube_scheduler_artifact = "${ var.kube_scheduler_artifact }"
    cloud_config_file = "${ base64encode(var.cloud_config_file) }"
    ca = "${ base64encode(var.ca) }"
    ca_key = "${ base64encode(var.ca_key) }"
    apiserver = "${ base64encode(var.apiserver) }"
    apiserver_key = "${ base64encode(var.apiserver_key) }"
    controller = "${ base64encode(var.controller) }"
    controller_key = "${ base64encode(var.controller_key) }"
    scheduler = "${ base64encode(var.scheduler) }"
    scheduler_key = "${ base64encode(var.scheduler_key) }"
    known_tokens_csv = "${ base64encode(data.template_file.known_tokens_csv.rendered) }"
    kube_controller_manager_kubeconfig = "${ base64encode(data.template_file.kube_controller_manager_kubeconfig.rendered)  }"
    kube_scheduler_kubeconfig = "${ base64encode(data.template_file.kube_scheduler_kubeconfig.rendered) }"
    dns_conf = "${ base64encode(var.dns_conf) }"
    dns_dhcp = "${ base64encode(var.dns_dhcp) }"

  }
}
