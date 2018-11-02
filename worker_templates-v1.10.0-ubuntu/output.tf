output "worker_cloud_init" { value = "${ join("`",data.template_file.worker.*.rendered) }" }

