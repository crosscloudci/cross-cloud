resource "azurerm_public_ip" "master" {
  count = "${ var.master_node_count }"
  name  = "${ var.name }-master${ count.index + 1 }"
  location = "${ var.location }"
  resource_group_name = "${ var.name }"
  public_ip_address_allocation = "static"
  domain_name_label = "${ var.name }-master${ count.index + 1 }"
}

resource "azurerm_network_interface" "cncf" {
  count = "${ var.master_node_count }"
  name                = "master-interface${ count.index + 1 }"
  location            = "${ var.location }"
  resource_group_name = "${ var.name }"
  internal_dns_name_label = "${ var.name }${ count.index + 1 }"

  ip_configuration {
    name                          = "master-nic${ count.index + 1 }"
    subnet_id                     = "${ var.subnet_id }"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${ element(azurerm_public_ip.master.*.id, count.index) }"
    load_balancer_backend_address_pools_ids = [
      "${ azurerm_lb_backend_address_pool.cncf.id }",
      "${ azurerm_lb_backend_address_pool.apiserver_internal.id }",
    ]
  }
}

resource "azurerm_virtual_machine" "cncf" {
  count = "${ var.master_node_count }"
  name                  = "${ var.name }-master${ count.index + 1 }"
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
    name          = "master-disks${ count.index + 1 }"
    vhd_uri       = "${ var.storage_primary_endpoint }${ var.storage_container }/master-vhd${ count.index + 1 }.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "${ var.name }-master${ count.index + 1 }"
    admin_username = "${ var.admin_username }"
    admin_password = "Password1234!"
    custom_data = "${ element(split("`", var.master_cloud_init), count.index) }"
  }

  os_profile_linux_config {
    disable_password_authentication = false
 }
}
