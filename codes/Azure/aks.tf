resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  location            = data.azurerm_resource_group.this.location
  resource_group_name = var.resource_group_name
  local_account_disabled = true
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.k8s_version
  tags = {
    owner = var.owner
  }
  microsoft_defender{
    log_analytics_workspace_id = azurerm_log_analytics_workspace.loganaws.id
  }
  azure_active_directory_role_based_access_control {
    managed = true
    azure_rbac_enabled = true

  }

  default_node_pool {
    name                = var.default_node_pool_name
    vm_size             = var.vm_size
    node_count          = var.node_count
    vnet_subnet_id      = azurerm_subnet.default.id
    type                = "VirtualMachineScaleSets"
    tags = {
     owner = var.owner
    }  

    enable_auto_scaling = var.enable_auto_scaling
    max_count           = var.max_count
    min_count           = var.min_count
  }

  identity {
    type = "SystemAssigned"
  }

  #service_principal {
  #  client_id     = var.ARM_CLIENT_ID
  #  client_secret = var.ARM_CLIENT_SECRET
  #}

  network_profile {
    network_plugin     = "azure"
    network_policy     = "calico"
    dns_service_ip     = var.dns_service_ip
    #docker_bridge_cidr = var.docker_address
    service_cidr       = var.service_address
    load_balancer_sku  = "standard"
  }
  linux_profile {
    admin_username = var.username

    ssh_key {
      key_data = file(".key_pair/ssh_key.id_rsa.pub") # Specify your public key
    }
  }
  #lifecycle {
    #  prevent_destroy = true
    #}
}
