resource "azurerm_network_interface" "cncf" {
  count = "${ var.master_node_count }"
  name                = "etcd-interface${ count.index + 1 }"
  location            = "${ var.location }"
  resource_group_name = "${ var.name }"

  ip_configuration {
    name                          = "etcd-nic${ count.index + 1 }"
    subnet_id                     = "${ var.subnet_id }"
    private_ip_address_allocation = "dynamic"
    # private_ip_address            = "${ element( split(",", var.etcd-ips), count.index ) }"
    load_balancer_backend_address_pools_ids = ["${ azurerm_lb_backend_address_pool.cncf.id }"]
  }
}

resource "azurerm_virtual_machine" "cncf" {
  count = "${ var.master_node_count }"
  name                  = "etcd-master${ count.index + 1 }"
  location              = "${ var.location }"
  availability_set_id   = "${ var.availability_id }"
  resource_group_name = "${ var.name }"
  network_interface_ids = ["${ element(azurerm_network_interface.cncf.*.id, count.index) }"] 
  vm_size               = "${ var.master_vm_size }"

  storage_image_reference {
    publisher = "${ var.image_publisher }"
    offer     = "${ var.image_offer }"
    sku       = "${ var.image_sku }"
    version   = "${ var.image_version}"
  }

  storage_os_disk {
    name          = "etcd-disks${ count.index + 1 }"
    vhd_uri       = "${ var.storage_primary_endpoint }${ var.storage_container }/etcd-vhd${ count.index + 1 }.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "etcd-master${ count.index + 1 }"
    admin_username = "${ var.admin_username }"
    admin_password = "Password1234!"
    custom_data = "${ element(data.template_file.etcd_cloud_config.*.rendered, count.index) }"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path = "/home/${ var.admin_username }/.ssh/authorized_keys"
      key_data = "${file("${ var.data_dir }/.ssh/id_rsa.pub")}"
  }
 }
}
