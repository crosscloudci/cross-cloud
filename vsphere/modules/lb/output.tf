output "public_address" {
  #  value = "${aws_lb.xapi.dns_name}"
  value = "${aws_eip.xapi.public_ip}"
}
