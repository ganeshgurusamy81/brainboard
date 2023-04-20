resource "azurerm_resource_group" "ConnectivityRG" {
  tags     = merge(var.tags, {})
  location = "Central US"
}

resource "azurerm_virtual_network" "VNET-Connectivity" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.ConnectivityRG.name
  name                = "VNET-Connectivity"
  location            = "Central US"

  address_space = [
    var.addresssapce,
  ]
}

resource "azurerm_subnet" "connectivity-firewall-snet" {
  virtual_network_name = azurerm_virtual_network.VNET-Connectivity.name
  resource_group_name  = azurerm_resource_group.ConnectivityRG.name
}

resource "azurerm_subnet" "VPN-GW-Snet" {
  virtual_network_name = azurerm_virtual_network.VNET-Connectivity.name
  resource_group_name  = azurerm_resource_group.ConnectivityRG.name
}

resource "azurerm_subnet" "App-GW-Snet" {
  virtual_network_name = azurerm_virtual_network.VNET-Connectivity.name
  resource_group_name  = azurerm_resource_group.ConnectivityRG.name
  name                 = "AppGWSnet"
}

resource "azurerm_subnet" "APIM-Int-Snet" {
  virtual_network_name = azurerm_virtual_network.VNET-Connectivity.name
  resource_group_name  = azurerm_resource_group.ConnectivityRG.name
  name                 = "APIMIntSnet"
}

resource "azurerm_firewall" "Connectivity-FW" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.ConnectivityRG.name
  name                = "ConnectivityFW"
  location            = "Central US"
}

resource "azurerm_subnet" "Connectivity-CDN-Snet" {
  resource_group_name = azurerm_resource_group.ConnectivityRG.name
  name                = "ConnectivityCDNSnet"
}

resource "azurerm_cdn_frontdoor_endpoint" "Frontdoor-CDN" {
  tags = merge(var.tags, {})
  name = "FrontdoorCDNGeoFilter"
}

resource "azurerm_cdn_frontdoor_firewall_policy" "FrontdoorCDN-GeoFilter" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.ConnectivityRG.name
}

resource "azurerm_firewall_policy" "Frontdoor-GW-WAF" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.ConnectivityRG.name
  name                = "FrontdoorGWWAF"
  location            = "Central US"
}

resource "azurerm_vpn_gateway" "VPN-GW" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.ConnectivityRG.name
  name                = "VPNGW"
  location            = "Central US"
}

resource "azurerm_application_gateway" "application_gateway_15" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.ConnectivityRG.name
}

