resource "azurerm_public_ip" "agw_pip" {
  name                = var.app_gw_ip
  location            = var.location
  resource_group_name = var.azurerm_resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
}


resource "azurerm_public_ip" "public_ip" {
  name                = var.Vm_PUBLIC_IP
  location            = var.location
  resource_group_name = var.azurerm_resource_group
  allocation_method   = "Static"
  sku                 = "Standard"

}
