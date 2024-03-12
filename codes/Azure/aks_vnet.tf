resource "azurerm_virtual_network" "aks" {
  name                = var.vnet_name
  address_space       = [var.vnet_address_space]
  location            = data.azurerm_resource_group.this.location
  resource_group_name = var.resource_group_name
  tags = {
     owner = var.owner
  }
}

resource "azurerm_subnet" "default" {
  name                  = var.subnet_name
  resource_group_name   = var.resource_group_name
  virtual_network_name  = azurerm_virtual_network.aks.name
  address_prefixes      = [var.subnet_address]
}
