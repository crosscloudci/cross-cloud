output "master_cloud_init" { value = "${ join("`", data.template_file.master.*.rendered) }" }
