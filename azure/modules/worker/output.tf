output "test_data" { value = "${ element(split(",", var.worker_cloud_init), 1) }" }

