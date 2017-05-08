resource "azurerm_network_security_group" "cncf" {
  name                = "${ var.name }"
  location            = "${ var.location}"
  resource_group_name = "${ var.name }"
}

resource "azurerm_subnet" "cncf" {
  name = "${ var.name }"
  resource_group_name = "${ var.name }"
  virtual_network_name = "${azurerm_virtual_network.cncf.name}"
  address_prefix = "10.0.10.0/24"
  route_table_id = "${ azurerm_route_table.cncf.id }"

}

resource "azurerm_virtual_network" "cncf" {
  name                = "${ var.name }"
  resource_group_name = "${ var.name }"
  address_space       = ["${ var.vpc_cidr }"]
  location            = "${ var.location }"
  dns_servers         = [
    "${ element(split( ",", file(var.name_servers_file) ),0) }",
    "${ element(split( ",", file(var.name_servers_file) ),1) }",
    "8.8.8.8"
  ]
  # getting dns servers in list form was difficult
  # module.vpc.azurerm_virtual_network.main: Creating...
  # address_space.#:     "" => "1"
  # address_space.0:     "" => "10.0.0.0/16"
  # dns_servers.#:       "" => "4"
  # dns_servers.0:       "" => "40.90.4.9"
  # dns_servers.1:       "" => "13.107.24.9"
  # dns_servers.2:       "" => "64.4.48.9"
  # dns_servers.3:       "" => "13.107.160.9"
}

resource "azurerm_route_table" "cncf" {
  name                = "${ var.name }"
  location            = "${ var.location }"
  resource_group_name = "${ var.name }"
}
