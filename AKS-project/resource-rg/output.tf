output "rg_output" {
  value = azurerm_resource_group.pro-rg.name
}

output "location_output" {
  value = azurerm_resource_group.pro-rg.location
}

output "RG_id_Output" {
  value = azurerm_resource_group.pro-rg.id
}

output "tags" {
  value = azurerm_resource_group.pro-rg.tags
}