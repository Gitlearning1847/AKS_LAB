resource "azurerm_subnet" "appgw_subnet" {
  name                 = var.appgw_subnet
  resource_group_name  = var.azurerm_resource_group
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.app_gway_address]
}


resource "azurerm_application_gateway" "appgw" {
  name                = var.myAppGateway
  location            = var.location
  resource_group_name = var.azurerm_resource_group

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = var.appGatewayIpConfig
    subnet_id = azurerm_subnet.appgw_subnet.id
  }

  frontend_ip_configuration {
    name                 = "appGatewayFrontendIP"
    public_ip_address_id = var.gw_ip_id
  }

  frontend_port {
    name = "frontendPort"
    port = 80
  }

  backend_address_pool {
    name = "backendPool"
  }

  backend_http_settings {
    name                  = "httpSettings"
    port                  = 80
    protocol              = "Http"
    cookie_based_affinity = "Disabled"
    request_timeout       = 30
  }

  http_listener {
    name                           = "httpListener"
    frontend_ip_configuration_name = "appGatewayFrontendIP"
    frontend_port_name             = "frontendPort"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "rule1"
    rule_type                  = "Basic"
    http_listener_name         = "httpListener"
    backend_address_pool_name  = "backendPool"
    backend_http_settings_name = "httpSettings"
    priority = "100"
  }

  tags = {
    environment = "Production"
  }
}