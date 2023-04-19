resource "azurerm_network_security_group" "nsg-north" {
  tags = {
    env = "Development"
  }
  resource_group_name = azurerm_resource_group.rsg-az-north1.name
  name                = "nsg-north"
  location            = "North Europe"
}

resource "azurerm_network_security_rule" "ssh-1" {
  source_port_range           = "*"
  source_address_prefix       = "*"
  resource_group_name         = azurerm_resource_group.rsg-az-north1.name
  protocol                    = "TCP"
  priority                    = "110"
  network_security_group_name = azurerm_network_security_group.nsg-north.name
  name                        = "SSH-1"
  direction                   = "Inbound"
  destination_port_range      = "22"
  destination_address_prefix  = "*"
  description                 = "SSH"
  access                      = "Allow"
}

resource "azurerm_resource_group" "rsg-az-north1" {
  tags = {
    env = "Development"
  }
  name     = "resource-group-1"
  location = "North Europe"
}

resource "azurerm_subnet" "snet-north" {
  virtual_network_name = azurerm_virtual_network.vnet-north.name
  resource_group_name  = azurerm_resource_group.rsg-az-north1.name
  name                 = "snet-north"
  address_prefixes     = ["192.168.20.0/26"]
}

resource "azurerm_virtual_network" "vnet-north" {
  tags = {
    env = "Development"
  }
  resource_group_name = azurerm_resource_group.rsg-az-north1.name
  name                = "vnet-north"
  location            = "North Europe"
  address_space = [
    "192.168.20.0/24",
  ]
}

