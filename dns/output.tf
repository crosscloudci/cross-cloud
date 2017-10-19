output "corefile" { value = "${ data.template_file.corefile.rendered }" }

output "dns" { value = "${ data.template_file.dns.rendered }" }

