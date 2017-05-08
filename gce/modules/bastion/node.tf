resource "google_compute_instance" "cncf" {
  name         = "${ var.name }"
  machine_type = "n1-standard-1"
  zone         = "${ var.zone }"

  tags = ["bastion", "bar"]

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
    user-data = "${ data.template_file.user-data.rendered }"
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

data "template_file" "user-data" {
  template = "${ file( "${ path.module }/user-data.yml" )}"

  vars {
    internal_tld = "${ var.internal_tld }"
  }
}



# resource "azurerm_public_ip" "cncf" {
#   name  = "PublicIPForBastion"
#   location = "${ var.location }"
#   resource_group_name = "${ var.name }"
#   public_ip_address_allocation = "static"
#   domain_name_label = "bastion${ var.name }"
# }

# resource "azurerm_network_interface" "cncf" {
#   name                = "${ var.name }"
#   location            = "${ var.location }"
#   resource_group_name = "${ var.name }"

#   ip_configuration {
#     name                          = "${ var.name }"
#     subnet_id                     = "${ var.subnet-id }"
#     private_ip_address_allocation = "dynamic"
#     public_ip_address_id          = "${ azurerm_public_ip.cncf.id }"
#   }
# }

# resource "azurerm_virtual_machine" "cncf" {
#   name                = "${ var.name }"
#   location            = "${ var.location }"
#   availability_set_id   = "${ var.availability-id }"
#   resource_group_name = "${ var.name }"
#   network_interface_ids = ["${azurerm_network_interface.cncf.id}"]
#   vm_size               = "${ var.bastion-vm-size }"

#   storage_image_reference {
#     publisher = "${ var.image-publisher }"
#     offer     = "${ var.image-offer }"
#     sku       = "${ var.image-sku }"
#     version   = "${ var.image-version}"
#   }

#   storage_os_disk {
#     name          = "disk2"
#     vhd_uri       = "${ var.storage-primary-endpoint }${ var.storage-container }/disk2.vhd"
#     caching       = "ReadWrite"
#     create_option = "FromImage"
#   }

#   os_profile {
#     computer_name  = "hostname"
#     admin_username = "${ var.admin_username }"
#     admin_password = "Password1234!"
#     custom_data = "${ data.template_file.user-data.rendered }"
#     #custom_data = "${file("${path.module}/user-data2.yml")}"
#   }

#   os_profile_linux_config {
#     disable_password_authentication = true
#     ssh_keys {
#      path = "/home/${ var.admin_username }/.ssh/authorized_keys"
#      key_data = "${file("/cncf/data/.ssh/id_rsa.pub")}"
#     }
#   }
# }

# data "template_file" "user-data" {
#   template = "${ file( "${ path.module }/user-data.yml" )}"
#   vars {
#     internal_tld = "${ var.internal_tld }"
#   }
# }
