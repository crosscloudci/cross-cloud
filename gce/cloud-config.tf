# #Gen Certs
# resource "null_resource" "cloud_gen" {

#   provisioner "local-exec" {
#     command = <<COMMAND
# cat <<JSON > ${ var.data-dir }/azure-config.json
# {
#   "aadClientId": "$${ARM_CLIENT_ID}",
#   "aadClientSecret": "$${ARM_CLIENT_SECRET}",
#   "tenantId": "$${ARM_TENANT_ID}",
#   "subscriptionId": "$${ARM_SUBSCRIPTION_ID}",
#   "resourceGroup": "${ var.name }",
#   "location": "${ var.location }",
#   "subnetName": "${ var.name }",
#   "securityGroupName": "${ var.name }",
#   "vnetName": "${ var.name }",
#   "routeTableName": "${ var.name }",
#   "primaryAvailabilitySetName": "${ var.name }"
# }
# JSON
# COMMAND
#   }

#   provisioner "local-exec" {
#     when = "destroy"
#     on_failure = "continue"
#     command = <<EOF
#     rm -rf ${ var.data-dir }/azure-config.json
# EOF
#   }

# }

# resource "null_resource" "dummy_dependency4" {
#   depends_on = [ "null_resource.cloud_gen" ]
# }

