resource "google_compute_region_backend_service" "cncf" {
  name             = "${ var.name }"
  region           = "${ var.region }"
  protocol         = "TCP"
  timeout_sec      = 10
  session_affinity = "CLIENT_IP"

  backend {
    group = "${google_compute_instance_group.cncf.self_link}"
  }

    health_checks = ["${google_compute_health_check.cncf.self_link}"]
}

resource "google_compute_target_pool" "cncf" {
  name = "${var.name}-external"

  instances = [
    "${google_compute_instance.cncf.*.self_link}"
  ]

  # health_checks = ["${google_compute_health_check.cncf.self_link}"]
}

resource "google_compute_instance_group" "cncf" {
  name       = "${ var.name }"
  instances  = ["${google_compute_instance.cncf.*.self_link}"]

  named_port = {
    name = "http"
    port = "8080"
  }

  named_port {
    name = "https"
    port = "443"
  }

  zone        = "${ var.zone }"
}

resource "google_compute_instance" "cncf" {
  count        = "${ var.master_node_count }"
  name         = "${ var.name }-master${ count.index + 1 }"
  machine_type = "n1-standard-1"
  zone         = "${ var.zone }"

  tags = ["foo", "bar"]

  disk {
    image = "coreos-stable-1298-7-0-v20170401"
  }

  // Local SSD disk
  disk {
    type    = "local-ssd"
    scratch = true
  }

  network_interface {
    # network = "${ var.name }"
    subnetwork = "${ var.name }"
    subnetwork_project = "${ var.project }"

    access_config {
      // FIX ME Don't assign Public IP
      // Ephemeral IP
    }
  }

  metadata {
    user-data = "${ element(data.template_file.cloud-config.*.rendered, count.index) }"
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

resource "google_compute_health_check" "cncf" {
  name         = "${ var.name }"
  check_interval_sec = 30
  healthy_threshold = 2
  unhealthy_threshold  = 2
  timeout_sec = 3

  http_health_check {
    port = "8080"
    host = ""
    request_path = "/"
  }
}

