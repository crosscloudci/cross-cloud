resource "google_container_cluster" "cncf" {
  name               = "${ var.name }"
  min_master_version = "${ var.min_master_version }"
  zone               = "${ var.zone }"
  initial_node_count = "${ var.node_count }"

  network            = "${ var.network }"
  subnetwork         = "${ var.subnetwork }"
  node_version       = "${ var.node_version }"

  master_auth {
    username         = "${ var.master_user }"
    password         = "${ var.master_password }"
  }

  node_config {
    machine_type     = "${ var.vm_size }"
    image_type       = "${ var.image_type }"
    oauth_scopes     = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}


resource "null_resource" "file" {

  provisioner "local-exec" {
    command = <<LOCAL_EXEC
echo "${ base64decode(google_container_cluster.cncf.master_auth.0.cluster_ca_certificate) }" > "${ var.data_dir }/ca.pem"
echo  "${ base64decode(google_container_cluster.cncf.master_auth.0.client_certificate) }" > "${ var.data_dir }/k8s-admin.pem"
echo "${ base64decode(google_container_cluster.cncf.master_auth.0.client_key) }" > "${ var.data_dir }/k8s-admin-key.pem"
LOCAL_EXEC
  }
}
