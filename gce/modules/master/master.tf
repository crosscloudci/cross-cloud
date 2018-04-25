

resource "google_compute_instance" "cncf" {
  count        = "${ var.master_node_count }"
  name         = "${ var.name }-master${ count.index + 1 }"
  machine_type = "${ var.master_vm_size }"
  can_ip_forward = true

  tags = ["kubernetes-master", "kubernetes-minion"]

  boot_disk {
    initialize_params {
    image = "${ var.image_id }"
    }
  }

  network_interface {
    subnetwork = "${ var.name }"

    access_config {
    }
  }

  metadata {
    user-data = "${ element(split("`", var.master_cloud_init), count.index) }"
  }

  service_account {
    scopes = ["userinfo-email", "compute-rw", "storage-ro"]
  }
}