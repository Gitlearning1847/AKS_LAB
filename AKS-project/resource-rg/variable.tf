variable "azurerm_resource_group" {
  description = "this is the resource group for this project"
  type = string
}

variable "location" {
  description = "east us is the perfer location for deployment"
  type = string
}

variable "tags" {
  type = map(string) 
  description = "please add tag to every resource"
}