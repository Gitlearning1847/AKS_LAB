resource "azurerm_virtual_network" "vm-vnet" {
  name                = var.VM_Vnet
  location            = var.location
  resource_group_name = var.azurerm_resource_group
  address_space       = [var.VM_address_Space]
}


resource "azurerm_virtual_network" "AKS-vnet" {
  name                = var.AKS_VNET
  location            = var.location
  resource_group_name = var.azurerm_resource_group
  address_space       = [var.AKS_Address_Space]
}



resource "azurerm_virtual_network" "ACR-vnet" {
  name                = var.ACR_VNET
  location            = var.location
  resource_group_name = var.azurerm_resource_group
  address_space       = [var.ACR_Address_Space]
}

resource "azurerm_subnet" "VM_Subnet" {  
  name                 = var.VM_SUBNET
  resource_group_name  = var.azurerm_resource_group
  virtual_network_name = azurerm_virtual_network.vm-vnet.name
  address_prefixes     = [var.VM_SUBNET_PREFIXES]
}

resource "azurerm_subnet" "AKS_SUBNET" {
  name                 = var.AKS_SUBNET
  resource_group_name  = var.azurerm_resource_group
  virtual_network_name = azurerm_virtual_network.AKS-vnet.name
  address_prefixes     = [var.AKS_SUBNET_PREFIXES]
  

}

resource "azurerm_subnet" "sql_endpoint_subnet" {
  name                 = var.sql_endpoint_subnet
  resource_group_name  = var.azurerm_resource_group
  virtual_network_name = azurerm_virtual_network.AKS-vnet.name
  address_prefixes     = [var.sql_endpoint_subnet_prefix]
  

}


resource "azurerm_subnet" "ACR_SUBNET"{
  name                 = var.ACR_SUBNET
  resource_group_name  = var.azurerm_resource_group
  virtual_network_name = azurerm_virtual_network.ACR-vnet.name
  address_prefixes     = [var.ACR_SUBNET_PREFIXES]
}

resource "azurerm_subnet" "ACR_Pe"{
  name                 = "privet_endpoint"
  resource_group_name  = var.azurerm_resource_group
  virtual_network_name = azurerm_virtual_network.ACR-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_virtual_network_peering" "VM_TO_ACR" {
  name                      = "VM_TO_ACR"
  resource_group_name       = var.azurerm_resource_group
  virtual_network_name      = azurerm_virtual_network.vm-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.ACR-vnet.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering"  "ACR_TO_VM" {
  name                      = "ACR_TO_VM"
  resource_group_name       = var.azurerm_resource_group
  virtual_network_name      = azurerm_virtual_network.ACR-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.vm-vnet.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "AKS_TO_ACR" {
  name                      = "AKS_TO_ACR"
  resource_group_name       = var.azurerm_resource_group
  virtual_network_name      = azurerm_virtual_network.AKS-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.ACR-vnet.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering"  "ACR_TO_AKS"{
  name                      = "ACR_TO_AKS"
  resource_group_name       = var.azurerm_resource_group
  virtual_network_name      = azurerm_virtual_network.ACR-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.AKS-vnet.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "VM_TO_AKS" {
  name                      = "VM_TO_AKS"
  resource_group_name       = var.azurerm_resource_group
  virtual_network_name      = azurerm_virtual_network.vm-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.AKS-vnet.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering"  "AKS_TO_VM" {
  name                      = "AKS_TO_VM"
  resource_group_name       = var.azurerm_resource_group
  virtual_network_name      = azurerm_virtual_network.AKS-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.vm-vnet.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_network_security_group" "AKS_NSG" {
  name                = var.AKS_NSG
  location            = var.location
  resource_group_name = var.azurerm_resource_group

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTPS"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association"  "AKS_NSG" {
  subnet_id                 = azurerm_subnet.AKS_SUBNET.id
  network_security_group_id = azurerm_network_security_group.AKS_NSG.id
}

resource "azurerm_network_security_group" "VM_NSG" {
  name                = var.vm_NSG
  location            = var.location
  resource_group_name = var.azurerm_resource_group

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTPS"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association"  "vm_NSG" {
  subnet_id                 = azurerm_subnet.VM_Subnet.id
  network_security_group_id = azurerm_network_security_group.VM_NSG.id
}



resource "azurerm_route_table" "route" {
  name                = var.azurerm_route_table
  location            = var.location
  resource_group_name = var.azurerm_resource_group

  
}

resource "azurerm_subnet_route_table_association" "lab_route" {
  subnet_id      = azurerm_subnet.AKS_SUBNET.id
  route_table_id = azurerm_route_table.route.id
}

