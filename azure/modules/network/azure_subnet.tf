resource "azurerm_subnet" "cncf" {
  name                 = "${ var.name }-subnet"
  resource_group_name  = "${ var.name }"
  virtual_network_name = "${ var.name}"
  address_prefix       = "${ var.subnet_cidr }"
}
