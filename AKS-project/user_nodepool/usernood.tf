
data "azurerm_subnet" "AKS_SUBNET" {
  name                 = "AKS_SUBNET"              
  virtual_network_name = "AKS_VNET"              
  resource_group_name  = "pro-rg001"              
}



resource "azurerm_kubernetes_cluster_node_pool" "linux101" {
  name                  = var.user_node
  kubernetes_cluster_id = var.AKS_ID
  vm_size               = "Standard_DS2_v2"
  vnet_subnet_id        = data.azurerm_subnet.AKS_SUBNET.id
  mode                  = var.mode
  zones                 = var.zones

  min_count           = null
  max_count           = null
  node_count          = 1

  os_disk_type = "Managed"
  os_type      = "Linux"

  node_labels = {
    "nodepool-type" = "User"
    "environment"   = "dev"
    "nodepoolos"    = "linux"
    "app"           = "user-apps"
  }

  upgrade_settings {
    max_surge = "33%"
  }

  tags = var.tags
}