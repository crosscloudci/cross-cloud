output "master_cloud_init" { value = "${ join(",", data.template_file.etcd_cloud_config.*.rendered) }" }
