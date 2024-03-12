resource "azurerm_resource_group" "terraform-devsecops-test" {
  name     = var.resource_group_name 
  location = var.region
}
