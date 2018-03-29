data "template_file" "dns_conf" {
  template = "${ file( "${ path.module }/dns.conf" )}"
  vars {
    discovery_nameserver = "${ var.discovery_nameserver }"
    upstream_dns = "${ var.upstream_dns }"
  }
}

data "template_file" "dns_dhcp" {
  template = "${ file( "${ path.module }/dns_dhcp.conf" )}"
  vars {
    discovery_nameserver = "${ var.discovery_nameserver }"
  }
}

resource "null_resource" "master_etcd" {
  count = "${ var.master_node_count }"

  provisioner "local-exec" {
    when = "create"
    on_failure = "fail"
    command = <<EOF
    #Master Host Record
    curl -XPUT http://"${ var.etcd_server }"/v2/keys/skydns/local/"${ var.cloud_provider }"/"${ var.name }"/"${ var.name}-master-${ count.index +1 }" \
    -d value='{"host":"${ element(split(",", var.master_ips), count.index) }"}'
    
    # Etcd SRV Records
    curl -XPUT http://"${ var.etcd_server}"/v2/keys/skydns/local/"${ var.cloud_provider }"/"${ var.name }"/_tcp/_etcd-server/"${ var.name }-master-${ count.index +1 }" \
    -d value='{"host":"${ var.name }-master-${ count.index +1 }.${ var.name }.${ var.cloud_provider }.local","port":2380,"priority":0,"weight":0}'
    curl -XPUT http://"${ var.etcd_server}"/v2/keys/skydns/local/"${ var.cloud_provider }"/"${ var.name }"/_tcp/_etcd-client/"${ var.name }-master-${ count.index +1 }" \
    -d value='{"host":"${ var.name }-master-${ count.index +1 }.${ var.name }.${ var.cloud_provider }.local","port":2379,"priority":0,"weight":0}'

    # ETCD Host Records
    curl -XPUT http://"${ var.etcd_server }"/v2/keys/skydns/local/"${ var.cloud_provider }"/"${ var.name }"/etcd/"${ var.name }-master-${ count.index +1 }" \
    -d value='{"host":"${ element(split(",", var.master_ips), count.index) }"}'

    # Public Master Record
    curl -XPUT http://"${ var.etcd_server }"/v2/keys/skydns/local/"${ var.cloud_provider }"/"${ var.name }"/master/"${ var.name }-master-${ count.index +1 }" \
    -d value='{"host":"${ element(split(",", var.public_master_ips), count.index) }"}'

    # Internal-Master Record
    curl -XPUT http://"${ var.etcd_server }"/v2/keys/skydns/local/"${ var.cloud_provider }"/"${ var.name }"/internal-master/"${ var.name }-master-${ count.index +1 }" \
    -d value='{"host":"${ element(split(",", var.master_ips), count.index) }"}'
EOF
  }
}

resource "null_resource" "worker_etcd" {
  count = "${ var.worker_node_count }"

  provisioner "local-exec" {
    when = "create"
    on_failure = "fail"
    command = <<EOF
    #Worker Host Record
    curl -XPUT http://"${ var.etcd_server }"/v2/keys/skydns/local/"${ var.cloud_provider }"/"${ var.name }"/"${ var.name }-worker-${ count.index +1 }" \
    -d value='{"host":"${ element(split(",", var.worker_ips), count.index) }"}'
EOF
  }
}

resource "null_resource" "cleanup_etcd" {

  provisioner "local-exec" {
    when = "destroy"
    on_failure = "fail"
    command = <<EOF
    curl -L http://"${ var.etcd_server }"/v2/keys/skydns/local/"${ var.cloud_provider }"/"${ var.name }"\?recursive\=true -XDELETE
EOF
  }

}