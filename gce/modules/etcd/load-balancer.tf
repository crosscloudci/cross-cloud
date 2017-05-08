# resource "azurerm_public_ip" "cncf" {
#   name = "PublicIPForLB"
#   location = "${ var.location }"
#   resource_group_name = "${ var.name }"
#   public_ip_address_allocation = "static"
#   domain_name_label = "k8s${ var.name }"
# }

# resource "azurerm_lb" "cncf" {
#   name = "TestLoadBalancer"
#   location = "${ azurerm_public_ip.cncf.location }"
#   resource_group_name = "${ azurerm_public_ip.cncf.resource_group_name }"

#   frontend_ip_configuration {
#     name = "PublicIPAddress"
#     public_ip_address_id = "${azurerm_public_ip.cncf.id}"
#   }
# }

# resource "azurerm_lb_rule" "cncf" {
#   resource_group_name = "${azurerm_public_ip.cncf.resource_group_name}"
#   loadbalancer_id = "${azurerm_lb.cncf.id}"
#   probe_id = "${ azurerm_lb_probe.cncf.id }"
#   backend_address_pool_id = "${ azurerm_lb_backend_address_pool.cncf.id }"
#   name = "LBRule"
#   protocol = "Tcp"
#   frontend_port = 443
#   backend_port = 443
#   frontend_ip_configuration_name = "PublicIPAddress"
# }

# resource "azurerm_lb_probe" "cncf" {
#   resource_group_name = "${azurerm_public_ip.cncf.resource_group_name}"
#   loadbalancer_id = "${azurerm_lb.cncf.id}"
#   name = "${ var.name }"
#   protocol = "Http"
#   port = 8080
#   request_path = "/"
#   interval_in_seconds = 30
#   number_of_probes = 5
# }

# resource "azurerm_lb_backend_address_pool" "cncf" {
#   resource_group_name = "${ azurerm_public_ip.cncf.resource_group_name }"
#   loadbalancer_id = "${azurerm_lb.cncf.id}"
#   name = "BackEndAddressPool"
# }
