terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.30.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "580c5bee-bb0b-4b9c-91fd-9bcb9d1e2eaa"
}

module "pro-rg" {
  source                 = "./resource-rg"
  azurerm_resource_group = var.azurerm_resource_group
  location               = var.location
  tags                   = var.tags
}


module "vnet" {
  source                 = "./network-service"
  azurerm_resource_group = module.pro-rg.rg_output
  AKS_Address_Space      = var.AKS_Address_Space
  ACR_Address_Space      = var.ACR_Address_Space
  AKS_VNET               = var.AKS_VNET
  ACR_VNET               = var.ACR_VNET
  VM_address_Space       = var.VM_address_Space
  VM_Vnet                = var.VM_Vnet
  location               = module.pro-rg.location_output
  ACR_SUBNET             = var.ACR_SUBNET
  AKS_SUBNET             = var.AKS_SUBNET
  ACR_SUBNET_PREFIXES    = var.ACR_SUBNET_PREFIXES
  VM_SUBNET              = var.VM_SUBNET
  VM_SUBNET_PREFIXES     = var.VM_SUBNET_PREFIXES
  AKS_SUBNET_PREFIXES    = var.AKS_SUBNET_PREFIXES
 AKS_NSG = var.AKS_NSG
 vm_NSG = var.vm_NSG
 azurerm_route_table = var.azurerm_route_table
 sql_endpoint_subnet = var.sql_endpoint_subnet
 sql_endpoint_subnet_prefix = var.sql_endpoint_subnet_prefix
}


module "AKS"{
 source = "./AKS"
 acr_name = var.acr_name
 AKS_NAME = var.AKS_NAME
 acr_pe = var.acr_pe
 azurerm_resource_group = module.pro-rg.rg_output
 default_pool = var.default_pool
 location = module.pro-rg.location_output
 log_ana_name = var.log_ana_name
 subnet_id = module.vnet.subnet_id_out
 acr_subnet_id = module.vnet.acr_endpoint_out
 tags = module.pro-rg.tags
 vnet_id = module.vnet.aks_vnet_id


}

module "gateway" {
  source = "./Application_gateway"
  azurerm_resource_group = module.pro-rg.rg_output
  location = module.pro-rg.location_output
  app_gway_address = var.app_gway_address
  appGatewayIpConfig = var.appGatewayIpConfig
  appgw_subnet = var.appgw_subnet
  myAppGateway = var.myAppGateway
  vnet_name = module.vnet.aks_vnet_name
  gw_ip_id = module.public_ip.gw_ip_id_out
}
# Arthur
module "public_ip" {
  source = "./public_ip"
  app_gw_ip = var.app_gw_ip
  azurerm_resource_group = module.pro-rg.rg_output
  location = module.pro-rg.location_output
  Vm_PUBLIC_IP = var.Vm_PUBLIC_IP
}
# Arthur
module "mssql" {
  source = "./SQL_batabase"
  mssql_endpoint_name = var.mssql_endpoint_name
  location = module.pro-rg.location_output
  mssql_endpoint_subnet_id = module.vnet.sql_subnet
  Mssql_firewall_name = var.Mssql_firewall_name
  sql_admin_password = var.sql_admin_password
  sql_admin_username = var.sql_admin_username
  sql_database_name = var.sql_database_name
  azurerm_resource_group = module.pro-rg.rg_output
  sql_server_name = var.sql_server_name
  tags = module.pro-rg.tags
  vnet_id = module.vnet.aks_vnet_id
   
}
# Arthur
module "User_Node" {
  source = "./user_nodepool"
  AKS_ID = module.AKS.AKS_out
  mode = var.mode
   tags = module.pro-rg.tags
   zones = var.zones
   user_node = var.user_node

}