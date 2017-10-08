output "external_elb" { value = "${ aws_elb.external.dns_name }" }
output "internal_elb" { value = "${ aws_elb.internal.dns_name }" }

output "hostname_prefix" { value = "${ replace(join(",", "${ aws_instance.master.*.private_ip }"), ".", "-") }" }
