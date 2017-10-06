output "worker" { value = ["${ data.template_file.worker_cloud_config.*.rendered }"] }
