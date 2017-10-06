output "external_lb" { value = "${ azurerm_lb_backend_address_pool.cncf.id }" }
output "fqdn_lb" { value = "${ azurerm_public_ip.cncf.fqdn }" }
output "master_ips" { value = ["${ azurerm_network_interface.cncf.*.private_ip_address }"] }
output "dns_suffix" { value = "${ replace("${azurerm_network_interface.cncf.0.internal_fqdn}", "${ var.name}1.", "")}" }
output "cloud_config_file" { value = "${ gzip_me.cloud_config_file.output }" }
output "kube_proxy_token" { value = "${ random_string.kube_proxy.result }" }
