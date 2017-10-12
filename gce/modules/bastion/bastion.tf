resource "google_compute_instance" "cncf" {
  name         = "${ var.name }"
  machine_type = "${ var.bastion_vm_size }"
  zone         = "${ var.zone }"

  tags = ["bastion"]

  disk {
    image = "${ var.image_id }"
  }

  // Local SSD disk
  disk {
    type    = "local-ssd"
    scratch = true
  }

  network_interface {
    subnetwork = "${ var.name }"
    subnetwork_project = "${ var.project }"

  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}
