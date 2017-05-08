resource "azurerm_network_interface" "cncf" {
  count               = "${ var.worker_node_count }"
  name                = "worker-interface${ count.index + 1 }"
  location            = "${ var.location }"
  resource_group_name = "${ var.name }"

  ip_configuration {
    name                          = "worker-nic${ count.index + 1 }"
    subnet_id                     = "${ var.subnet_id }"
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_virtual_machine" "cncf" {
  count = "${ var.worker_node_count }"
  name                  = "worker-node${ count.index + 1 }"
  location              = "${ var.location }"
  availability_set_id   = "${ var.availability_id }"
  resource_group_name   = "${ var.name }"
  network_interface_ids = ["${ element(azurerm_network_interface.cncf.*.id, count.index) }"]
  vm_size               = "${ var.worker_vm_size }"

  storage_image_reference {
    publisher = "${ var.image_publisher }"
    offer     = "${ var.image_offer }"
    sku       = "${ var.image_sku }"
    version   = "${ var.image_version}"
  }

  storage_os_disk {
    name          = "worker-disks${ count.index + 1 }"
    vhd_uri       = "${ var.storage_primary_endpoint }${ var.storage_container }/worker-vhd${ count.index + 1 }.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "worker-node${ count.index + 1 }"
    admin_username = "${ var.admin_username }"
    admin_password = "Password1234!"
    custom_data = "${ element(data.template_file.worker_cloud_config.*.rendered, count.index) }"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path = "/home/${ var.admin_username }/.ssh/authorized_keys"
      key_data = "${file("${ var.data_dir }/.ssh/id_rsa.pub")}"
  }
 }
}
