output "public_address" {
  value = "${aws_eip.xapi.public_ip}"
}
