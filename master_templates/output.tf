output "master" { value = ["${ data.template_file.etcd_cloud_config.*.rendered }"] }
