
resource "azurerm_virtual_network" "cncf" {
  name                = "${ var.name }"
  address_space       = ["${ var.vpc_cidr }"]
  location            = "${ var.location }"
  resource_group_name = "${ var.name }"

  subnet {
    name           = "${ var.name }-subnet"
    address_prefix = "${ var.subnet_cidr }"
  }
}

data "azurerm_subnet" "cncf" {
  name                 = "${ var.name }-subnet"
  virtual_network_name = "${ var.name }"
  resource_group_name  = "${ var.name }"
}
