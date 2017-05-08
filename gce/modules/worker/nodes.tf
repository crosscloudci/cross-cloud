resource "google_compute_instance" "cncf" {
  count        = "${ var.worker_node_count }"
  name         = "${ var.name }-worker${ count.index + 1 }"
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
    user-data = "${ data.template_file.cloud-config.rendered }"
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

# resource "azurerm_network_interface" "cncf" {
#   count               = "${ var.worker_node_count }"
#   name                = "worker-interface${ count.index + 1 }"
#   location            = "${ var.location }"
#   resource_group_name = "${ var.name }"

#   ip_configuration {
#     name                          = "worker-nic${ count.index + 1 }"
#     subnet_id                     = "${ var.subnet-id }"
#     private_ip_address_allocation = "dynamic"
#   }
# }

# resource "azurerm_virtual_machine" "cncf" {
#   count = "${ var.worker_node_count }"
#   name                  = "worker-node${ count.index + 1 }"
#   location              = "${ var.location }"
#   availability_set_id   = "${ var.availability-id }"
#   resource_group_name   = "${ var.name }"
#   network_interface_ids = ["${ element(azurerm_network_interface.cncf.*.id, count.index) }"]
#   vm_size               = "${ var.worker-vm-size }"

#   storage_image_reference {
#     publisher = "${ var.image-publisher }"
#     offer     = "${ var.image-offer }"
#     sku       = "${ var.image-sku }"
#     version   = "${ var.image-version}"
#   }

#   storage_os_disk {
#     name          = "worker-disks${ count.index + 1 }"
#     vhd_uri       = "${ var.storage-primary-endpoint }${ var.storage-container }/worker-vhd${ count.index + 1 }.vhd"
#     caching       = "ReadWrite"
#     create_option = "FromImage"
#   }

#   os_profile {
#     computer_name  = "worker-node${ count.index + 1 }"
#     admin_username = "${ var.admin_username }"
#     admin_password = "Password1234!"
#     custom_data = "${ element(data.template_file.cloud-config.*.rendered, count.index) }"
#   }

#   os_profile_linux_config {
#     disable_password_authentication = true
#     ssh_keys {
#       path = "/home/${ var.admin_username }/.ssh/authorized_keys"
#       key_data = "${file("/cncf/data/.ssh/id_rsa.pub")}"
#   }
#  }
# }


