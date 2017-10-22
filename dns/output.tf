output "corefile" { value = "${ data.template_file.corefile.rendered }" }

output "dns_master" { value = "${ data.template_file.dns_master.rendered }" }

output "dns_worker" { value = "${ data.template_file.dns_worker.rendered}"}

output "dns_conf" { value = "${ data.template_file.dns_conf.rendered }" }

output "dns_etcd" { value = "${ data.template_file.etcd_proxy.rendered }"}



