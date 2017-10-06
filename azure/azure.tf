# Enable the GZIP Provider
provider "gzip" {
  compressionlevel = "BestCompression"
}

resource "random_id" "cncf" {
  byte_length = 8
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "${ var.subscription_id }"
  client_id       = "${ var.client_id }"
  client_secret   = "${ var.client_secret }"
  tenant_id       = "${ var.tenant_id }"
}


resource "azurerm_resource_group" "cncf" {
  name     = "${ var.name }"
  location = "${ var.location }"
}

resource "azurerm_storage_account" "cncf" {
  name                = "${ random_id.cncf.dec }"
  resource_group_name = "${ var.name }"
  location            = "${ var.location }"
  account_type        = "Standard_LRS"
}

resource "azurerm_storage_container" "cncf" {
  name                  = "${ var.name }"
  resource_group_name   = "${ var.name }"
  storage_account_name  = "${ azurerm_storage_account.cncf.name }"
  container_access_type = "private"
}

resource "azurerm_availability_set" "cncf" {
  name                = "${ var.name }"
  resource_group_name = "${ var.name }"
  location            = "${ var.location }"
}


# Create Azure Cloud Config
resource "gzip_me" "cloud_config_file" {
  input = "${ data.template_file.cloud_config_file.rendered }"
}

data "template_file" "cloud_config_file" {
  template = "${ file( "${ path.module }/azure_cloud.json" )}"
  vars {
    client_id = "${ var.client_id }"
    client_secret = "${ var.client_secret }"
    tenant_id = "${ var.tenant_id }"
    subscription_id = "${ var.subscription_id }"
    name = "${ var.name }"
    location = "${ var.location }"
    subnet_name = "subnet-${ var.name}"
  }
}
