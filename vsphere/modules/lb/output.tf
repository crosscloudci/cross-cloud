output "host_name" {
  value = "${aws_lb.xapi.dns_name}"
}
