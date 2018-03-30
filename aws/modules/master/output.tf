output "public_master_ips" { value = "${ aws_instance.master.*.public_ip }" }
output "master_ips" { value = "${ aws_instance.master.*.private_ip }" }

