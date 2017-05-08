#Gen Certs and SSH KeyPair
resource "null_resource" "ssl_ssh_cloud_gen" {

  provisioner "local-exec" {
    command = <<EOF
${ path.module }/init-cfssl \
${ var.data_dir }/.cfssl \
${ azurerm_resource_group.cncf.location } \
${ var.internal_tld } \
${ var.k8s_service_ip }
EOF
  }

  provisioner "local-exec" {
    when = "destroy"
    on_failure = "continue"
    command = <<EOF
rm -rf ${ var.data_dir }/.cfssl
EOF
  }

  provisioner "local-exec" {
    command = <<EOF
mkdir -p ${ var.data_dir }/.ssh
ssh-keygen -t rsa -f ${ var.data_dir }/.ssh/id_rsa -N ''
EOF
  }

  provisioner "local-exec" {
    when = "destroy"
    on_failure = "continue"
    command = <<EOF
    rm -rf ${ var.data_dir }/.ssh
EOF
  }

  provisioner "local-exec" {
    command = <<COMMAND
cat <<JSON > ${ var.data_dir }/azure-config.json
{
  "aadClientId": "$${ARM_CLIENT_ID}",
  "aadClientSecret": "$${ARM_CLIENT_SECRET}",
  "tenantId": "$${ARM_TENANT_ID}",
  "subscriptionId": "$${ARM_SUBSCRIPTION_ID}",
  "resourceGroup": "${ var.name }",
  "location": "${ var.location }",
  "subnetName": "${ var.name }",
  "securityGroupName": "${ var.name }",
  "vnetName": "${ var.name }",
  "routeTableName": "${ var.name }",
  "primaryAvailabilitySetName": "${ var.name }"
}
JSON
COMMAND
  }

  provisioner "local-exec" {
    when = "destroy"
    on_failure = "continue"
    command = <<EOF
    rm -rf ${ var.data_dir }/azure-config.json
    EOF
  }

}

resource "null_resource" "dummy_dependency" {
  depends_on = [ "null_resource.ssl_ssh_cloud_gen" ]
}

