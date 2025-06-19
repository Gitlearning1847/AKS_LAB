output "gw_ip_id_out" {
  value = azurerm_public_ip.agw_pip.id
}

output  "vm_pu_id" {
value = azurerm_public_ip.public_ip.id
}
 