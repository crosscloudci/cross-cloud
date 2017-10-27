data "template_file" "corefile" {
  template = "${ file( "${ path.module }/corefile" )}"
  vars {
    domain = "${ var.domain }"
  }
}

data "template_file" "dns_master" {
  template = "${ file( "${ path.module }/dns-master.yml" )}"
}

data "template_file" "dns_worker" {
  template = "${ file( "${ path.module }/dns-worker.yml" )}"
}

data "template_file" "dns_conf" {
  template = "${ file( "${ path.module }/dns.conf" )}"
}


data "template_file" "etcd_proxy" {
  template = "${ file( "${ path.module }/etcd-proxy.yml" )}"
  vars {
    etcd_image = "${ var.etcd_image }"
    etcd_tag = "${ var.etcd_tag }"
    etcd_discovery = "${ var.etcd_discovery }"

  }
}
