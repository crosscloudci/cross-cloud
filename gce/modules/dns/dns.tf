# domain - (Required) The domain to add the record to
# name - (Required) The name of the record
# value - (Required) The value of the record
# type - (Required) The type of the record
# ttl - (Optional) The TTL of the record
# priority - (Optional) The priority of the record - only useful for some record typesi

resource "dnsimple_record" "A-public-endpoint" {
  name = "endpoint.${ var.name }"
  value = "${ var.external_lb}"
  type = "A"
  ttl = "${ var.record_ttl }"
  domain = "${ var.domain }"
}

resource "dnsimple_record" "A-internal-lb" {
  name = "master.${ var.name }"
  value = "${ var.internal_lb}"
  type = "A"
  ttl = "${ var.record_ttl }"
  domain = "${ var.domain }"
}
