output "subnet_id_out"{
  value = azurerm_subnet.AKS_SUBNET.id
}

output "acr_endpoint_out" {
   value = azurerm_subnet.ACR_Pe.id
}

output "aks_vnet_name" {
  value = azurerm_virtual_network.AKS-vnet.name
}

output "sql_subnet" {
  value = azurerm_subnet.sql_endpoint_subnet.id
}

output "aks_vnet_id" {
  value = azurerm_virtual_network.AKS-vnet.id
}

output "vm_subnet_id" {
  value = azurerm_subnet.VM_Subnet.id
}