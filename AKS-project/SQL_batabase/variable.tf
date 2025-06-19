variable "azurerm_resource_group" {
  type = string
}

variable "location" {
  type = string

}

variable "tags" {
  type = map(string)
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

variable "vnet_id" {
  type = string
}

variable "Mssql_firewall_name" {
  type = string
}

variable "mssql_endpoint_name" {
   type = string
}

 variable "mssql_endpoint_subnet_id" {
   type = string
 }