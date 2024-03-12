resource "random_string" "loganaws" {
  length  = 4
  special = false
  min_lower = 1
  min_numeric = 1
  min_upper = 1
  keepers = {
    loganaws_name = var.loganaws_name
  }
}

resource "azurerm_log_analytics_workspace" "loganaws" {
  name                = "${random_string.loganaws.keepers.loganaws_name}${random_string.loganaws.id}"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
