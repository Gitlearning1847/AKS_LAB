variable "azurerm_resource_group" {
  type = string
}

variable "location" {
  type = string
}

variable "tags" {
  type = map(string)
}


variable "VM_address_Space" {
  type = string
}

variable "AKS_VNET" {
  type = string
}

variable "AKS_Address_Space" {
  type = string
}

variable "ACR_VNET" {
  type = string
}

variable "ACR_Address_Space" {
  type = string
}

variable "VM_Vnet" {
  type = string
}

variable "AKS_SUBNET" {
  type = string
}

variable "AKS_SUBNET_PREFIXES" {
  type = string
}

variable "VM_SUBNET" {
  type = string
}

variable "VM_SUBNET_PREFIXES" {
  type = string
}

variable "ACR_SUBNET" {
  type = string
}

variable "ACR_SUBNET_PREFIXES" {
  type = string
}
 
variable "AKS_NSG" {
  type = string
}
 variable "vm_NSG" {
  type = string
}


variable "Vm_PUBLIC_IP" {
  type = string
}
variable "appgw_subnet"{
  type = string
}

variable "app_gway_address" {
  type = string
}

variable "myAppGateway" {
  type = string
}

variable "appGatewayIpConfig" {
  type = string
}

variable "app_gw_ip" {
  type = string
}

variable "acr_name" {
  type = string
}

variable "AKS_NAME" {
 type =string 
}

variable "log_ana_name" {
  type = string
}

variable "acr_pe" {
 type = string
}

variable "default_pool" {
  type = string
}


variable "azurerm_route_table" {
  type = string
}
  
variable "sql_endpoint_subnet" {
   type = string
 }

 variable "sql_endpoint_subnet_prefix" {
   type = string
 }

 variable "sql_server_name" {
  type = string
}

variable "sql_database_name" {
  type = string
}

variable "sql_admin_username" {
  type = string
}

variable "sql_admin_password" {
  type = string
}


variable "Mssql_firewall_name" {
  type = string
}

variable "mssql_endpoint_name" {
   type = string
}

variable "user_node" {
  type = string
}


variable "zones" {
  type = list(string)
}

variable "mode" {
  type = string
}


 