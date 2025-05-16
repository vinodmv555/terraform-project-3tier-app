# Resource 1: Create Resoruce Group 
resource "azurerm_resource_group" "rg_myapp" {
  name     = local.rg_name
  location = var.location
  tags     = local.common_tags
}

# Resource 2: Create Virtual Network 
module "vnet_myapp" {
  source              = "Azure/vnet/azurerm"
  version             = "~> 5.0.1"
  resource_group_name = azurerm_resource_group.rg_myapp.name
  vnet_location       = var.location
  vnet_name           = "vnet-${var.environment}-${var.location}"
  address_space       = ["10.0.0.0/16"]
  subnet_names        = ["AzureBastionSubnet", "vm-subnet", "appgw-subnet"]
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}
# Resoruce 3: Public IP for bastion
resource "azurerm_public_ip" "bastion_ip" {
  name                = "bastion"
  location            = azurerm_resource_group.rg_myapp.location
  resource_group_name = azurerm_resource_group.rg_myapp.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Resoruce 3: Bastion for VNet
resource "azurerm_bastion_host" "vnet_bastion" {
  name                = "bastion_ip"
  location            = azurerm_resource_group.rg_myapp.location
  resource_group_name = azurerm_resource_group.rg_myapp.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = module.vnet_myapp.vnet_subnets[0]
    public_ip_address_id = azurerm_public_ip.bastion_ip.id
  }
}


# Resource 4: NSG group 
resource "azurerm_network_security_group" "nsg_myapp" {
  name                = "allow-22-80-443"
  location            = azurerm_resource_group.rg_myapp.location
  resource_group_name = azurerm_resource_group.rg_myapp.name

  dynamic "security_rule" {
    for_each = local.nsg_ports
    content {
      name                       = "inbound-rule-${security_rule.key}"
      description                = "Inbound Rule ${security_rule.key}"
      priority                   = sum([100, security_rule.key])
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}

# Resource 5: Associate NSG group to vm subnet 
resource "azurerm_subnet_network_security_group_association" "name" {
  subnet_id                 = module.vnet_myapp.vnet_subnets[2]
  network_security_group_id = azurerm_network_security_group.nsg_myapp.id
}

# Resource 5: Virtual Machine

# Resoruce 6: App gateway 
