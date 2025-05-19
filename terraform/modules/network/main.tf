# Create Azure Resource Group
resource "azurerm_resource_group" "rg_webapp" {
  name     = "rg-${var.environment}-${var.application_name}"
  location = var.location
}

# Create Azure Virtual Network 
resource "azurerm_virtual_network" "vnet_webapp" {
  name                = "vnet-${var.environment}-${var.application_name}"
  location            = azurerm_resource_group.rg_webapp.location
  resource_group_name = azurerm_resource_group.rg_webapp.name
  address_space       = var.vnet_address_space
}

# Create Subnets in VNet 
resource "azurerm_subnet" "subnets_webapp_vnet" {
  for_each = { for subnet in var.subnets : subnet.name => subnet }

  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.rg_webapp.name
  virtual_network_name = azurerm_virtual_network.vnet_webapp.name
  address_prefixes     = [each.value.address_prefix]
}

# Create NSG for compute subnet
resource "azurerm_network_security_group" "nsg_compute_subnet" {
  name                = "nsg-${var.nsg_name}"
  location            = azurerm_resource_group.rg_webapp.location
  resource_group_name = azurerm_resource_group.rg_webapp.name
}

# Add NSG rules
resource "azurerm_network_security_rule" "nsg_compute_subnet_rules" {
  for_each = var.allowed_ports

  name                        = "allow-${each.key}"
  priority                    = 100 + index(keys(var.allowed_ports), each.key)
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = each.value
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg_webapp.name
  network_security_group_name = azurerm_network_security_group.nsg_compute_subnet.name
}

# NSG Association with compute subnet
resource "azurerm_subnet_network_security_group_association" "nsg_compute_subnet_assocation" {
  #subnet_id                 = azurerm_subnet.app_subnets[var.compute_subnet_namee].id
  subnet_id                 = azurerm_subnet.subnets_webapp_vnet[var.compute_subnet_name].id
  network_security_group_id = azurerm_network_security_group.nsg_compute_subnet.id
  #network_security_group_id = azurerm_network_security_group.app_nsg.id
}

# Create public ip for azure bastion
resource "azurerm_public_ip" "pip_webapp_vnet_bastion" {
  count               = var.enable_bastion ? 1 : 0
  name                = "pip-${var.bastion_name}"
  location            = azurerm_resource_group.rg_webapp.location
  resource_group_name = azurerm_resource_group.rg_webapp.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Create Azure Bastion
resource "azurerm_bastion_host" "bastion_webapp_vnet" {
  count               = var.enable_bastion ? 1 : 0
  name                = var.bastion_name
  location            = azurerm_resource_group.rg_webapp.location
  resource_group_name = azurerm_resource_group.rg_webapp.name

  ip_configuration {
    name                 = "bastion-ip-config"
    subnet_id            = azurerm_subnet.subnets_webapp_vnet["AzureBastionSubnet"].id
    public_ip_address_id = azurerm_public_ip.pip_webapp_vnet_bastion[0].id
  }
}

# DB NSG 
resource "azurerm_network_security_group" "nsg_db_subnet" {
  name                = var.db_nsg_name
  location            = azurerm_resource_group.rg_webapp.location
  resource_group_name = azurerm_resource_group.rg_webapp.name
}

resource "azurerm_network_security_rule" "nsg_db_subnet_rules" {
  for_each = var.db_allowed_ports

  name = "allow-${each.key}"
  priority = 200 + index(keys(var.db_allowed_ports), each.key)
  direction = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_address_prefix       = "*"
  source_port_range           = "*"
  destination_address_prefix  = "*"
  destination_port_range      = each.value
  resource_group_name         = azurerm_resource_group.rg_webapp.name
  network_security_group_name  = azurerm_network_security_group.nsg_db_subnet.name
}

# Associate NSG with db subnet
resource "azurerm_subnet_network_security_group_association" "nsg_db_subnet_association" {
  subnet_id = azurerm_subnet.subnets_webapp_vnet[var.db_subnet_name].id
  network_security_group_id = azurerm_network_security_group.nsg_db_subnet.id
}