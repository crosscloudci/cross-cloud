# data "template_file" "corefile" {
#   template = "${ file( "${ path.module }/corefile" )}"
#   vars {
#     name = "${ var.name }"
#     etcd_bootstrap = "http://${ var.etcd_bootstrap }"
#   }
# }

data "template_file" "dns_master" {
  template = "${ file( "${ path.module }/dns-master.yml" )}"
}

# data "template_file" "dns_worker" {
#   template = "${ file( "${ path.module }/dns-worker.yml" )}"
# }

data "template_file" "dns_conf" {
  template = "${ file( "${ path.module }/dns.conf" )}"
  vars {
    discovery_nameserver = "${ var.discovery_nameserver }"
  }
}


# data "template_file" "etcd_proxy" {
#   template = "${ file( "${ path.module }/etcd-proxy.yml" )}"
#   vars {
#     etcd_image = "${ var.etcd_image }"
#     etcd_tag = "${ var.etcd_tag }"
#     etcd_discovery = "${ var.etcd_discovery }"

#   }
# }
