resource "azurerm_public_ip" "cncf" {
  name  = "PublicIPForBastion"
  location = "${ var.location }"
  resource_group_name = "${ var.name }"
  public_ip_address_allocation = "static"
  domain_name_label = "bastion${ var.name }"
}

resource "azurerm_network_interface" "cncf" {
  name                = "${ var.name }"
  location            = "${ var.location }"
  resource_group_name = "${ var.name }"

  ip_configuration {
    name                          = "${ var.name }"
    subnet_id                     = "${ var.subnet_id }"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${ azurerm_public_ip.cncf.id }"
  }
}

resource "azurerm_virtual_machine" "cncf" {
  name                = "${ var.name }"
  location            = "${ var.location }"
  availability_set_id   = "${ var.availability_id }"
  resource_group_name = "${ var.name }"
  network_interface_ids = ["${azurerm_network_interface.cncf.id}"]
  vm_size               = "${ var.bastion_vm_size }"

  storage_image_reference {
    publisher = "${ var.image_publisher }"
    offer     = "${ var.image_offer }"
    sku       = "${ var.image_sku }"
    version   = "${ var.image_version}"
  }

  storage_os_disk {
    name          = "disk2"
    vhd_uri       = "${ var.storage_primary_endpoint }${ var.storage_container }/disk2.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "${ var.admin_username }"
    admin_password = "Password1234!"
    custom_data = "${ data.template_file.bastion-user-data.rendered }"
    #custom_data = "${file("${path.module}/user-data2.yml")}"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
     path = "/home/${ var.admin_username }/.ssh/authorized_keys"
      key_data = "${file("${ var.data_dir }/.ssh/id_rsa.pub")}"
    }
  }
}

data "template_file" "bastion-user-data" {
  template = "${ file( "${ path.module }/bastion-user-data.yml" )}"
  vars {
    internal_tld = "${ var.internal_tld }"
  }
}
