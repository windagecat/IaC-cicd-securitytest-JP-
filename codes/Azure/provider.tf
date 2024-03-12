terraform {
  required_providers {
     azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
     }
     azuread = {
      source = "hashicorp/azuread"
      version = "~>2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
  backend "azurerm" {
    key = "terraform.tfstate"
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}
provider "azuread" {
}

#resource "azurerm_resource_group" "this" {
#  name     = var.resource_group_name
#  location = var.region
#  tags     = var.tags_def
#}
