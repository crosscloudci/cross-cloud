data "template_file" "dns_conf" {
  template = "${ file( "${ path.module }/dns.conf" )}"
  vars {
    discovery_nameserver = "${ var.discovery_nameserver }"
  }
}

resource "null_resource" "etcd" {
  count = "3"

  provisioner "local-exec" {
    when = "create"
    on_failure = "fail"
    command = <<EOF
    curl -XPUT http://"${ var.etcd_server }"/v2/keys/skydns/local/"${ var.cloud_provider }"/"${ element(packet_device.infra.*.hostname, count.index) }" \
    -d value='{"host":"${ element(packet_device.infra.*.access_public_ipv4, count.index) }"}'
    curl -XPUT http://"${ var.etcd_server }"/v2/keys/skydns/io/goppa-internal/"${ element(packet_device.worker.*.hostname, count.index) }" \
    -d value='{"host":"${ element(packet_device.worker.*.access_public_ipv4, count.index) }"}'
    curl -XPUT http://"${ var.etcd_server}"/v2/keys/skydns/io/goppa-internal/_tcp/_etcd-server/"${ element(packet_device.infra.*.hostname, count.index) }" \
    -d value='{"host":"${ element(packet_device.infra.*.hostname, count.index) }.goppa-internal.io","port":2380,"priority":0,"weight":0}'
    curl -XPUT http://"${ var.etcd_server}"/v2/keys/skydns/io/goppa-internal/_tcp/_etcd-client/"${ element(packet_device.infra.*.hostname, count.index) }" \
    -d value='{"host":"${ element(packet_device.infra.*.hostname, count.index) }.goppa-internal.io","port":2379,"priority":0,"weight":0}'
    curl -XPUT http://"${ var.etcd_server }"/v2/keys/skydns/io/goppa-internal/etcd/"${ element(packet_device.infra.*.hostname, count.index) }" \
    -d value='{"host":"${ element(packet_device.infra.*.access_public_ipv4, count.index) }"}'
    curl -XPUT http://"${ var.etcd_server }"/v2/keys/skydns/io/goppa-internal/master/"${ element(packet_device.infra.*.hostname, count.index) }" \
    -d value='{"host":"${ element(packet_device.infra.*.access_public_ipv4, count.index) }"}'
    curl -XPUT http://"${ var.etcd_server }"/v2/keys/skydns/io/goppa-internal/internal-master/"${ element(packet_device.infra.*.hostname, count.index) }" \
    -d value='{"host":"${ element(packet_device.infra.*.access_public_ipv4, count.index) }"}'
EOF
  }

  provisioner "local-exec" {
    when = "destroy"
    on_failure = "fail"
    command = <<EOF
    curl -L http://"${ var.etcd_server }"/v2/keys/skydns/io/goppa-internal\?recursive\=true -XDELETE
EOF
  }

}