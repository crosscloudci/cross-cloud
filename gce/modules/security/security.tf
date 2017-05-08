resource "google_compute_firewall" "allow-internal-lb" {
  name    = "allow-internal-lb"
  network = "${ var.name }"

  allow {
    protocol = "tcp"
    ports    = ["8080", "443"]
  }

  source_ranges = ["10.0.0.0/16"]
  target_tags = ["int-lb"]
}

resource "google_compute_firewall" "allow-health-check" {
  name    = "allow-health-check"
  network = "${ var.name }"

  allow {
    protocol = "tcp"
    ports = ["8080", "443"]
  }

  source_ranges = ["130.211.0.0/22","35.191.0.0/16","10.0.0.0/16"]
}

resource "google_compute_firewall" "allow-all-internal" {
  name    = "allow-all-10-128-0-0-20"
  network = "${ var.name }"

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["10.0.0.0/16"]
}

resource "google_compute_firewall" "allow-ssh-bastion" {
  name    = "allow-ssh-bastion"
  network = "${ var.name }"

  allow {
    protocol = "tcp"
    ports = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["bastion"]
}

resource "google_compute_firewall" "allow-kubectl" {
  name    = "allow-kubectl-lb"
  network = "${ var.name }"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["foo"]
}
