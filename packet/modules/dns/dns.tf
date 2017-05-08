# domain - (Required) The domain to add the record to
# name - (Required) The name of the record
# value - (Required) The value of the record
# type - (Required) The type of the record
# ttl - (Optional) The TTL of the record
# priority - (Optional) The priority of the record - only useful for some record typesi

resource "dnsimple_record" "A-etcd"  {
  count = "${ var.master_node_count }"
  name = "etcd.${ var.name }"
  value = "${ element(var.master_ips, count.index) }"
  type = "A"
  ttl = "${ var.record_ttl }"
  domain = "${ var.domain }"
}

resource "dnsimple_record" "A-etcds" {
  count = "${ var.master_node_count }"
  name = "etcd${ count.index+1 }.${ var.name }"
  value = "${ element(var.master_ips, count.index) }"
  type = "A"
  ttl = "${ var.record_ttl }"
  domain = "${ var.domain }"
}

resource "dnsimple_record" "A-masters" {
  count = "${ var.master_node_count }"
  name = "master${ count.index+1 }.${ var.name }"
  value = "${ element(var.master_ips, count.index) }"
  type = "A"
  ttl = "${ var.record_ttl }"
  domain = "${ var.domain }"
}

resource "dnsimple_record" "A-master" {
  count = "${ var.master_node_count }"
  name = "master.${ var.name }"
  value = "${ element(var.master_ips, count.index) }"
  type = "A"
  ttl = "${ var.record_ttl }"
  domain = "${ var.domain }"
}

resource "dnsimple_record" "A-public-endpoint" {
  count = "${ var.master_node_count }"
  name = "endpoint.${ var.name }"
  value = "${ element(var.public_master_ips, count.index) }"
  type = "A"
  ttl = "${ var.record_ttl }"
  domain = "${ var.domain }"
}

resource "dnsimple_record" "A-public-masters" {
  count = "${ var.master_node_count }"
  name = "master${ count.index + 1 }.public.${ var.name }"
  value = "${ element(var.public_master_ips, count.index) }"
  type = "A"
  ttl = "${ var.record_ttl }"
  domain = "${ var.domain }"
}

resource "dnsimple_record" "A-public-workers" {
  count = "${ var.worker_node_count }"
  name = "worker${ count.index + 1 }.${ var.name }"
  value = "${ element(var.public_worker_ips, count.index) }"
  type = "A"
  ttl = "${ var.record_ttl }"
  domain = "${ var.domain }"
}

# resource "dnsimple_record" "etcd-client-tcp" {
#    count = "${ var.master_node_count }"
#    name = "_etcd-client._tcp.${ var.name }"
#    value = "etcd${ count.index+1 }.${ var.name }.${ var.domain }."
#    type = "SRV"
#    ttl = "${ var.record_ttl }"
#    domain = "${ var.domain }"
# }

# resource "dnsimple_record" "etcd-server-tcp" {
#   count = "${ var.master_node_count }"
#   name = "_etcd-server-ssl._tcp.${ var.name }"
#   value = "etcd${ count.index+1 }.${ var.name }.${ var.domain }."
#   type = "SRV"
#   ttl = "${ var.record_ttl }"
#   domain = "${ var.domain }"
# }
