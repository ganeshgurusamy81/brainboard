resource "azurerm_linux_virtual_machine" "linux_virtual_machine_1" {
  tags     = merge(var.tags, {})
  location = "East US"
}

module "LB_2" {
  source = "git::https://github.com/terraform-azurerm-modules/terraform-azurerm-load-balancer"

  location = "East US"
}

