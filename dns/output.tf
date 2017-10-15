output "corefile" { value = "${ gzip_me.corefile.output }" }

output "dns" { value = "${ gzip_me.dns.output }" }

output "systemd" { value = "${ data.template_file.systemd.rendered }" }
