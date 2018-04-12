output "dns_conf" { value = "${ data.template_file.dns_conf.rendered }" }
output "dns_dhcp" { value = "${ data.template_file.dns_dhcp.rendered }" }


