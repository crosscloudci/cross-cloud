
output "external_elb" { value = "${ aws_elb.external.dns_name }" }
output "internal_ips" { value = "${ join(",", aws_instance.etcd.*.public_ip) }" }
output "master_ips" { value = ["${ aws_instance.etcd.*.private_ip }"] }

output "hostname_prefix" { value = "${ replace(join(",", "${ aws_instance.etcd.*.private_ip }"), ".", "-") }" }



