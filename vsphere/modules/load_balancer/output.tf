output "public_address" {
  value = "${element(data.dns_a_record_set.xapi.addrs, 0)}"
}
