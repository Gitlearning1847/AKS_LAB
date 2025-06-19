variable "VM_Vnet"{
  type = string
  description = "this is the vm vnet"
}

variable "azurerm_resource_group" {
  type = string
  
}

variable "location" {
  type = string

}

variable "VM_address_Space"{
  type = string
 
}

variable "AKS_VNET"{
  type = string
}

variable "AKS_Address_Space"{
  type = string 
}

variable "ACR_VNET" {
   type = string
   
}

variable "ACR_Address_Space"{
   type = string   
}

variable "AKS_SUBNET" {
 type = string 
}

variable "AKS_SUBNET_PREFIXES"{
  type = string
}

variable "VM_SUBNET" {
 type = string
}

variable "VM_SUBNET_PREFIXES" {
type = string
}

variable "ACR_SUBNET"{
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




variable "azurerm_route_table" {
  type = string
}
 
 variable "sql_endpoint_subnet" {
   type = string
 }

 variable "sql_endpoint_subnet_prefix" {
   type = string
 }