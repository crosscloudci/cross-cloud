resource "google_compute_instance" "cncf" {
  name         = "${ var.name }"
  machine_type = "${ var.bastion_vm_size }"
  zone         = "${ var.zone }"
  can_ip_forward = true

  tags = ["bastion"]

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

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}
