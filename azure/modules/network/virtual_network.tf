
resource "azurerm_virtual_network" "cncf" {
  name                = "${ var.name }"
  address_space       = ["${ var.vpc_cidr }"]
  location            = "${ var.location }"
  resource_group_name = "${ var.name }"
}



# resource "azurerm_network_security_group" "cncf" {
#   name                = "${ var.name }"
#   location            = "${ var.location}"
#   resource_group_name = "${ var.name }"
# }

# resource "azurerm_route_table" "cncf" {
#   name                = "${ var.name }"
#   location            = "${ var.location }"
#   resource_group_name = "${ var.name }"
# }
