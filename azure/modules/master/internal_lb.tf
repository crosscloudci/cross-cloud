resource "azurerm_lb" "apiserver_internal" {
  name                = "${ var.name }-internal"
  location            = "${ var.location }"
  resource_group_name = "${ var.name }"

  frontend_ip_configuration {
    name                 = "${ var.name }-lb-internal-ip"
    subnet_id            = "${ var.subnet_id }"
    private_ip_address_allocation = "Static"
    private_ip_address   = "${ var.internal_lb_ip }"
  }
}

resource "azurerm_lb_rule" "apiserver_internal" {
  resource_group_name = "${ var.name }"
  loadbalancer_id = "${ azurerm_lb.apiserver_internal.id }"
  probe_id = "${ azurerm_lb_probe.apiserver_internal.id }"
  backend_address_pool_id = "${ azurerm_lb_backend_address_pool.apiserver_internal.id }"
  name = "LBInternalRule"
  protocol = "tcp"
  frontend_port = 443
  backend_port = 443
  frontend_ip_configuration_name = "${ var.name }-lb-internal-ip"
}

resource "azurerm_lb_probe" "apiserver_internal" {
  resource_group_name = "${ var.name }"
  loadbalancer_id = "${ azurerm_lb.apiserver_internal.id}"
  name = "${ var.name }"
  protocol = "tcp"
  port = 443
}

resource "azurerm_lb_backend_address_pool" "apiserver_internal" {
  resource_group_name = "${ var.name }"
  loadbalancer_id = "${azurerm_lb.apiserver_internal.id}"
  name = "LBInternalBackend"
}
