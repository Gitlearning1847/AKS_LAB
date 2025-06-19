

# Create Azure Container Registry with Private Endpoint
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.azurerm_resource_group
  location            = var.location
  sku                 = "Premium"
  admin_enabled       = false
}

resource "azurerm_private_endpoint" "acr_pe" {
  name                = var.acr_pe
  location            = var.location
  resource_group_name = var.azurerm_resource_group
  subnet_id           =  var.acr_subnet_id

  private_service_connection {
    name                           = "acr-priv-conn"
    private_connection_resource_id = azurerm_container_registry.acr.id
    is_manual_connection           = false
    subresource_names              = ["registry"]
  }
}

# Create Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "log" {
  name                = var.log_ana_name
  location            = var.location
  resource_group_name = var.azurerm_resource_group
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_user_assigned_identity" "aks_identity" {
  name                = "aks-user-identity"
  location            = var.location
  resource_group_name = var.azurerm_resource_group
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.AKS_NAME
  location            = var.location
  resource_group_name = var.azurerm_resource_group
  dns_prefix          = "aks-private"
  private_cluster_enabled = true
  private_dns_zone_id    = azurerm_private_dns_zone.aks_api.id

  default_node_pool {
    name           = var.default_pool
    node_count     = 2
    vm_size        = "Standard_DS2_v2"
    vnet_subnet_id = var.subnet_id
  }

  identity {
    type                      = "UserAssigned"
   identity_ids  = [azurerm_user_assigned_identity.aks_identity.id]

  }

  
    
    
  

  network_profile {
    network_plugin     = "azure"
    load_balancer_sku  = "standard"
    outbound_type      = "userDefinedRouting"
    dns_service_ip     = "10.3.0.10"
    service_cidr       = "10.3.0.0/16"
  }

  tags = var.tags
}



# ACR to AKS integration
resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

 #Create the Private DNS Zone for AKS API server
resource "azurerm_private_dns_zone" "aks_api" {
  name                = "privatelink.centralus.azmk8s.io"
  resource_group_name = var.azurerm_resource_group
}

# 2. Link the DNS zone to your VNet
resource "azurerm_private_dns_zone_virtual_network_link" "aks_api_link" {
  name                  = "aks-api-dns-link"
  resource_group_name   = var.azurerm_resource_group
  private_dns_zone_name = azurerm_private_dns_zone.aks_api.name
  virtual_network_id    = var.vnet_id
}

resource "azurerm_role_assignment" "aks_dns_zone_contributor" {
  scope                = azurerm_private_dns_zone.aks_api.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_identity.principal_id
}

