terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true
  storage_use_azuread = true
  features {}
}

resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "tfstate${random_string.resource_code.result}"
  resource_group_name      = var.resource_group_name
  location                 = azurerm_resource_group.terraform-devsecops-test.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_nested_items_to_be_public = false
  shared_access_key_enabled = false
  default_to_oauth_authentication = true

  tags = {
    owner = var.owner
  }
}

resource "azurerm_storage_container" "tfstate" {
  count                 = length(local.storage_containers)
  name                  = local.storage_containers[count.index]
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
  
  lifecycle {
    prevent_destroy = true
  }
}

output "tfstate_storage_account" {
 value = azurerm_storage_account.tfstate.name
}