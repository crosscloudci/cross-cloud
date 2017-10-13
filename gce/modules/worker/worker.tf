resource "google_compute_instance" "cncf" {
  count        = "${ var.worker_node_count }"
  name         = "${ var.name }-worker${ count.index + 1 }"
  machine_type = "${ var.worker_vm_size }"
  zone         = "${ var.zone }"
  can_ip_forward = true

  tags = ["kubernetes-minion"]

  boot_disk {
    initialize_params {
    image = "${ var.image_id }"
    }
  }

  network_interface {
    subnetwork = "${ var.name }"
    subnetwork_project = "${ var.project }"

    access_config {
    }
  }

  metadata {
    user-data = "${ element(split(",", var.worker_cloud_init), count.index) }"
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}
