variable "acr_name" {
  type = string
}

variable "AKS_NAME" {
 type =string 
}

variable "log_ana_name" {
  type = string
}


variable "azurerm_resource_group" {
  type = string
}

variable "location" {
  type = string
}

variable "acr_pe" {
 type = string
}

variable "default_pool" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "acr_subnet_id" {
  type = string
}  
variable "tags" {
  type = map(string)
}

variable "vnet_id" {
  type = string
}
