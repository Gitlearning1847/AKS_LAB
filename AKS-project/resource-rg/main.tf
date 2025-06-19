resource "azurerm_resource_group" "pro-rg" {
  name     = var.azurerm_resource_group
  location = var.location
   tags = var.tags
}