resource "azurerm_resource_group" "ConnectivityRG" {
  tags     = merge(var.tags, {})
  location = "Central US"
}

resource "azurerm_virtual_network" "VNET-Connectivity" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.ConnectivityRG.name
  name                = "VNET-Connectivity"
  location            = var.location

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
  location            = var.location
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
  location            = var.location
}

resource "azurerm_vpn_gateway" "VPN-GW" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.ConnectivityRG.name
  name                = "VPNGW"
  location            = var.location
}

resource "azurerm_application_gateway" "App-GW" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.ConnectivityRG.name
  name                = "App-GW"
  location            = var.location
}

resource "azurerm_api_management" "api_management_16" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.ConnectivityRG.name
  location            = var.location
}

resource "azurerm_key_vault" "Connectivity_KVault" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.ConnectivityRG.name
  name                = "ConnectivityKVault"
  location            = "Central US"
}

resource "azurerm_private_dns_zone" "blob" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.ConnectivityRG.name
  name                = "blob"
}

resource "azurerm_private_dns_zone" "DNS-AzureCr" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.ConnectivityRG.name
  name                = "DNSAzureCr"
}

resource "azurerm_private_dns_zone" "DNS-Valutcore" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.ConnectivityRG.name
  name                = "DNSValutcore"
}

resource "azurerm_private_dns_zone" "DNS-Resolvers" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.ConnectivityRG.name
  name                = "DNSResolvers"
}

resource "azurerm_private_endpoint" "private_endpoint_22" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.ConnectivityRG.name
  location            = "Central US"
}

resource "azurerm_resource_group" "App-RG" {
  tags     = merge(var.tags, {})
  name     = "ApplicationRG"
  location = "Central US"
}

resource "azurerm_virtual_network" "Vnet-Ent-Npd-App-Platform" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.App-RG.name
  location            = "Central US"
}

resource "azurerm_subnet" "APP-LB-Snet" {
  virtual_network_name = azurerm_virtual_network.Vnet-Ent-Npd-App-Platform.name
  resource_group_name  = azurerm_resource_group.App-RG.name
  name                 = "APPLBSnet"
}

resource "azurerm_network_security_group" "APP-LB-Snet-NSG" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.App-RG.name
  name                = "APPLBSnetNSG"
}

resource "azurerm_lb" "App-LB" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.App-RG.name
  name                = "AppLB"
  location            = "Central US"
}

resource "azurerm_subnet" "K8s-Snet" {
  virtual_network_name = azurerm_virtual_network.Vnet-Ent-Npd-App-Platform.name
  resource_group_name  = azurerm_resource_group.App-RG.name
  name                 = "K8Snet"
}

resource "azurerm_network_security_group" "K8s-NSG" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.App-RG.name
  name                = "K8sNSG"
}

resource "azurerm_kubernetes_cluster" "kubernetes_cluster_30" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.App-RG.name

  default_node_pool {
    node_count = 2
    max_pods   = 2
  }
}

resource "azurerm_subnet" "Backend-Snet" {
  virtual_network_name = azurerm_virtual_network.Vnet-Ent-Npd-App-Platform.name
  resource_group_name  = azurerm_resource_group.App-RG.name
  name                 = "BackendSnet"
}

resource "azurerm_network_security_group" "network_security_group_32" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.App-RG.name
}

resource "azurerm_private_endpoint" "private_endpoint_33" {
  tags                = merge(var.tags, {})
  subnet_id           = azurerm_subnet.Backend-Snet.id
  resource_group_name = azurerm_resource_group.App-RG.name
}

resource "azurerm_sql_database" "sql_database_34" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.App-RG.name
  location            = "Central US"
}

resource "azurerm_redis_cache" "redis_cache_35" {
  tags                = merge(var.tags, {})
  subnet_id           = azurerm_subnet.Backend-Snet.id
  resource_group_name = azurerm_resource_group.App-RG.name
}

resource "azurerm_storage_blob" "storage_blob_36" {
}

resource "azurerm_key_vault" "key_vault_37" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.App-RG.name
}

resource "azurerm_container_registry" "container_registry_38" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.App-RG.name
}

resource "azurerm_servicebus_queue" "servicebus_queue_39" {
}

resource "azurerm_powerbi_embedded" "powerbi_embedded_40" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.App-RG.name
}

resource "azurerm_data_factory" "data_factory_41" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.App-RG.name
}

resource "azurerm_eventhub" "eventhub_42" {
  resource_group_name = azurerm_resource_group.App-RG.name
}

resource "azurerm_private_endpoint" "private_endpoint_43" {
  tags                = merge(var.tags, {})
  subnet_id           = azurerm_subnet.Backend-Snet.id
  resource_group_name = azurerm_resource_group.App-RG.name
}

resource "azurerm_private_endpoint" "private_endpoint_44" {
  tags                = merge(var.tags, {})
  subnet_id           = azurerm_subnet.Backend-Snet.id
  resource_group_name = azurerm_resource_group.App-RG.name
}

resource "azurerm_private_endpoint" "private_endpoint_45" {
  tags                = merge(var.tags, {})
  subnet_id           = azurerm_subnet.Backend-Snet.id
  resource_group_name = azurerm_resource_group.App-RG.name
}

resource "azurerm_synapse_private_link_hub" "synapse_private_link_hub_46" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.App-RG.name
}

resource "azurerm_private_endpoint" "private_endpoint_47" {
  tags                = merge(var.tags, {})
  subnet_id           = azurerm_subnet.Backend-Snet.id
  resource_group_name = azurerm_resource_group.App-RG.name
}

resource "azurerm_private_endpoint" "private_endpoint_48" {
  tags                = merge(var.tags, {})
  subnet_id           = azurerm_subnet.Backend-Snet.id
  resource_group_name = azurerm_resource_group.App-RG.name
}

resource "azurerm_private_endpoint" "private_endpoint_49" {
  tags                = merge(var.tags, {})
  subnet_id           = azurerm_subnet.Backend-Snet.id
  resource_group_name = azurerm_resource_group.App-RG.name
}

resource "azurerm_private_endpoint" "private_endpoint_50" {
  tags                = merge(var.tags, {})
  subnet_id           = azurerm_subnet.Backend-Snet.id
  resource_group_name = azurerm_resource_group.App-RG.name
}

resource "azurerm_synapse_workspace" "synapse_workspace_51" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.App-RG.name
}

resource "azurerm_subnet" "subnet_52" {
}

resource "azurerm_virtual_network" "virtual_network_53" {
  tags = merge(var.tags, {})
}

resource "azurerm_subnet" "subnet_54" {
  virtual_network_name = azurerm_virtual_network.virtual_network_53.name
}

resource "azurerm_subnet" "subnet_55" {
  virtual_network_name = azurerm_virtual_network.virtual_network_53.name
}

resource "azurerm_subnet" "subnet_56" {
  virtual_network_name = azurerm_virtual_network.virtual_network_53.name
}

resource "azurerm_private_endpoint" "private_endpoint_57" {
  tags      = merge(var.tags, {})
  subnet_id = azurerm_subnet.subnet_52.id
}

resource "azurerm_private_endpoint" "private_endpoint_58" {
  tags      = merge(var.tags, {})
  subnet_id = azurerm_subnet.subnet_52.id
}

resource "azurerm_private_endpoint" "private_endpoint_59" {
  tags      = merge(var.tags, {})
  subnet_id = azurerm_subnet.subnet_52.id
}

resource "azurerm_private_endpoint" "private_endpoint_60" {
  tags      = merge(var.tags, {})
  subnet_id = azurerm_subnet.subnet_52.id
}

resource "azurerm_network_security_group" "network_security_group_61" {
  tags = merge(var.tags, {})
}

resource "azurerm_network_security_group" "network_security_group_62" {
  tags = merge(var.tags, {})
}

resource "azurerm_network_security_group" "network_security_group_63" {
  tags = merge(var.tags, {})
}

